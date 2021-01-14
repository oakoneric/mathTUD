#!/usr/bin/python3

import sys
import heapq

ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ*"
# * is part of commands

def findNextBracket(text, bracket, pos):
    """Find first occurence of bracket after pos that is not preceded
    by backslash

    Return its position in text.
    None if not found.
    """
    while True:  # -1 = not found
        pos = text.find(bracket, pos)
        if pos == -1:
            return None
        if pos == 0 or text[pos - 1] != "\\":
            return pos
        pos = pos + 1  # not good, go to next possible position


def findNextAnyBracket(text, brackets, pos):
    """Find next occurence of any bracket in brackets after pos.

    Return its position and itself.
    -1, None if not found.
    """
    bracketposs = []
    for bracket in brackets:
        newbracket = (bracket, findNextBracket(text, bracket, pos))
        print("debug: tmp newbracket:", newbracket)
        if newbracket[1] is not None:
            bracketposs.append((bracket, findNextBracket(text, bracket, pos)))
    if len(bracketposs) == 0:
        return -1, None
    else:
        print("debug findNextAnyBracket list:", bracketposs)
        returnvalue = heapq.nsmallest(1, bracketposs, key=lambda pair: pair[1])[0]
        print("debug returnvalue", returnvalue)
        return heapq.nsmallest(1, bracketposs, key=lambda pair: pair[1])[0]


def findNextCommand(text, command, pos):
    """Find next occurence of the command command after pos in text.

    command must include the backslash
    Return the starting index of the command.
    Return -1 if not found.
    """
    while True:
        pos = text.find(command, pos)
        if pos == -1:
            return -1
        if pos + len(command) >= len(text):
            # command at end of text
            return pos
        if text[pos + len(command)] not in ALPHABET:
            return pos
        else:
            pos = pos + 1
            # and search again


def findFirstNonWhitespace(text, pos):
    """Find first thing after pos in text that is not whitespace

    (whitespace = " " for now)
    Returns:
        position of thing and thing
        if nothing is after pos, return (-1, None)
    """
    while pos > -1 and text[pos] == " " and pos < len(text):
        pos = pos + 1
    if pos == -1 or pos >= len(text):
        return -1, None
    else:
        return pos, text[pos]


def findBeginEnd(text, command, pos):
    """Find beginning and end of command and its argument.

    Later possible: takes several arguments.

    Returns:
        - position of start (= argument pos)
        - length of start
        - position of end
        - length of end

    Except:
        if text does not have command at pos, throw IllegalArgumentError
    """
    try:
        print(command + " should be " + text[pos: pos+len(command)])
        if text[pos: pos+len(command)] != command:
            raise IndexError()
    except IndexError:
            raise ValueError("command " + str(command)
                             + " does not start at position " + str(pos))
    openingPos, opening = findFirstNonWhitespace(text, pos + len(command))
    if openingPos == -1:
        raise ValueError("no argument found for command " + command
                         + " starting at position " + pos)
    print("debug openingPos=", openingPos, "opening=", opening)
    if opening == "{":
        bracketLevel = 1
        bracketPos = openingPos
        while bracketLevel > 0:
            print("debug bracketLevel=", bracketLevel, "bracketPos=",
                  bracketPos)
            bracket, bracketPos = findNextAnyBracket(
                text, "{" + "}", bracketPos + 1)
            print("debug bracket=", bracket, "bracketPos=", bracketPos)
            if bracket is None:
                raise ValueError("no suitable bracket found"
                                 + " for command " + str(command)
                                 + " at position " + str(position)
                                 + " with last bracketlevel "
                                 + str(bracketLevel) + ".")
            elif bracket == "{":
                bracketLevel = bracketLevel + 1
            elif bracket == "}":
                bracketLevel = bracketLevel - 1
            else:
                raise ValueError(
                    "output of findNextAnyBracket is invalid")
        return pos, openingPos - pos + 1, bracketPos, 1
    elif opening == "[":
        print("Warning!!")
        print("unsupported optional argument")
        print("command:", command, "openingPos:", openingPos)
        raise ValueError("unsupported optional argument")
    elif opening == "\\":
        # argument is something like \Omega or \norm a
        # ask user how much is still argument
        newlineBefore = text.rfind("\n", 0, openingPos)
        newlineAfter = text.find("\n", openingPos)
        print("How long is the argument of", command, "starting with",
              text[openingPos:openingPos + 5], "?")
        print("Line:", text[newlineBefore + 1: newlineAfter])
        arglength = int(input("Length"))
        return pos, openingPos - pos, openingPos + arglength, 0
    else:
        return pos, openingPos - pos, openingPos + 1, 0


def isArgumentBig(arg):
    """Is argument big such that \\left, \\right is needed?

    Return if arg probably needs big left and right delimiters.
    """
    if (r"\frac" in arg or r"\int" in arg or r"\limits" in arg
        or "\sum" in arg):
        print(arg, "is big because of \\frac")
        return True
    if len(arg) > 10:
        print("'" + arg + "'", "is long. Is it big? Enter = small, else: big")
        return len(input()) > 0
    if all([a in ALPHABET or a == " " for a in arg]):
        print(arg, "is small bc only alphabet")
        return False
    if "{" not in arg:
        print(arg, "is small bc there is no {")
        return False
    print(arg, "is big because I found no reason why it should be small")
    return True


def replaceCommand(text, openingPos, openingLength, closingPos,
                   closingLength, newOpening, newClosing, addLeftRight):
    """Replace command with the symbols.

    addLeftRight: if True, add \\left, \\right delimiter to the
    opening and closing if the argument appears to be big.
    if False, never add those delimiters.

    Returns:
        altered text
    """
    if openingPos == -1 or closingPos == -1:
        print("Warning")
        print("-------")
        print("the following replacement is invalid:")
        print("openingPos=", openingPos, "openingLength=", openingLength,
              "closingPos=", closingPos, "closingLenght=", closingLenght,
              "newOpening=", newOpening, "newClosing=", newClosing)
        print("-----------")
    else:
        argument = text[openingPos + openingLength:closingPos]
        if addLeftRight and isArgumentBig(argument):
            newOpening = r"\left" + newOpening
            newClosing = r"\right" + newClosing
        return (text[:openingPos] + newOpening
                + argument # argument
                + newClosing
                + text[closingPos + closingLength:])


def replaceAllOfOneCommand(text, command, newOpening, newClosing,
                           addLeftRight):
    """Clean text of command.

    Replace all occurances of the commmand command with
    the newOpening and newClosing.

    Returns altered text.
    """
    pos = 0
    while True:
        pos = findNextCommand(text, command, pos)
        if pos == -1:
            return text
        pos, openingLength, closingPos, closingLength = findBeginEnd(
            text, command, pos)
        text = replaceCommand(text, pos, openingLength, closingPos,
                              closingLength, newOpening, newClosing,
                              addLeftRight)


def replaceArgumentLessCommand(text, command, replacement):
    """Clean text of commmand.

    Command cannot have arguments.
    Replace with replacement.

    Returns:
        altered text
    """
    pos = 0
    while True:
        pos = findNextCommand(text, command, pos)
        if pos == -1:
            return text
        text = text[:pos] + replacement + text[pos + len(command):]


if __name__ == "__main__":
    textfilename = sys.argv[1]
    with open(textfilename, mode="r") as textfile:
        textext = textfile.read()
        toBeReplacedWithArgument = [
            (r"\norm*", r"\|", r"\|", False),
            (r"\abs*", r"|", r"|", False),
            (r"\halfnorm*", r"|", r"|", False),
            (r"\set*", r"\{", r"\}", False),
            (r"\norm", r"\|", r"\|", True),
            (r"\abs", r"|", r"|", True),
            (r"\halfnorm", r"|", r"|", True),
            (r"\set", r"\{", r"\}", True)
        ]
        toBeReplacedWithoutArgument = [
            (r"\coloneqq", ":="),
            (r"\eqqcolon", "=:"),
            (r"\abschluss", r"\bar"),
            (r"\rand", r"\boundary"),
            (r"\leqC", r"\lesssim"),
            (r"\subsetneq", r"\subsetneqq")
        ]
        for (myCommand, myOpening, myClosing,
             ifdelims) in toBeReplacedWithArgument:
            textext = replaceAllOfOneCommand(textext, myCommand, myOpening,
                                             myClosing, ifdelims)
            # print("new text after replacing ", myCommand, "\n", textext)
        for (myCommand, myReplacement) in toBeReplacedWithoutArgument:
            textext = replaceArgumentLessCommand(textext, myCommand,
                                                 myReplacement)
    with open(textfilename, mode="w") as textfile:
        textfile.write(textext)
