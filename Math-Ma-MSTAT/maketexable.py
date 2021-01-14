#!/usr/bin/python3

import sys
import heapq

ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ*"

# TODO: automatic abbreviation handling
# TODO: math mode detection. E.g. for warning for \\ outside of mathmode
# TODO: in warning function externalise and make more general option of
# ignoring. Then useful for \overset{n → ∞}{\longrightarrow}

"""String indicating a command that probably should be changed:"""
TOCHECK = "TOCHECK"
"""String indicating that a command is already checked."""
CHECKED = "CHECKED"

"""LaTeX comment character"""
TEXCOMMENT = r"%"

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

def guessNextBracketPair(text, pos, opening, closing, maxArgLen):
    """Find next pair of opening and closing in text after pos which are
    at most maxArgLen characters apart.
    This is a good guess for a bracket pair.

    return (None, None) is not found.
    """
    openingPos = findNextBracket(text, opening, pos)
    if openingPos is None:
        return (None, None)
    closingPos = findNextBracket(text, closing, openingPos + len(opening))
    if (closingPos is None
        or closingPos - openingPos - len(opening) > maxArgLen
        or opening in text[openingPos + len(opening):closingPos]):
        # unlikely pair found
        # but still possible, so do not search for more bc that's error prone
        return (None, None)
    else:
        return (openingPos, closingPos)


def replaceNextBracketPair(text, pos, opening, closing, maxArgLen,
                           replacementCommand, replacementClosing):
    """Replace the next bracket pair in text after pos by the replacement
    command.

    Return the changed text and the first position after
    the replacement. None if no replacement.
    """
    openingPos, closingPos = guessNextBracketPair(text, pos, opening,
                                                  closing, maxArgLen)
    if openingPos is None:
        return text, None
    else:
        text = (text[:openingPos] + replacementCommand
                + text[openingPos + len(opening) : closingPos]
                + replacementClosing + text[closingPos + len(closing):])
        return text, (closingPos + len(replacementCommand) - len(opening)
                      + len(replacementClosing))


def replaceAllBracketPairs(text, opening, closing, maxArgLen,
                           replacementCommand, replacementClosing):
    """Replace all found pairs of the given brackets by the given replacement.
    """
    pos = 0
    while pos is not None:
        text, pos = replaceNextBracketPair(text, pos, opening, closing,
                                           maxArgLen, replacementCommand,
                                           replacementClosing)
    return text


def findNextCommandNotAsOpt(text, badCommand, pos):
    """Find next instance of badCommand after pos in text that is not in [ ].

    \\Big and \\big and \\bigg and \\Bigg
    are not interesting if they are optional arguments
    to \\set, \\klammern, etc. So ignore cases of those.
    """
    while pos != -1:
        pos = findNextCommand(text, badCommand, pos)
        if pos == -1:  # not found
            return -1
        if (pos == 0 or text[pos - 1] != "["
            or pos + len(badCommand) >= len(text)
            or text[pos + len(badCommand)] != "]"):
            return pos
        # else:
        pos = pos + 1  # do not find the same one again


def insertWarnings(lines, badCommand):
    """Insert warnings after a command that is probably to be checked.

    The text is to be given as a list of lines.
    A command in this sense can be any text that is not to be
    followed by an asciiletter
    """
    lineNumber = 0
    while lineNumber < len(lines):
        # if it is a comment, we do not need to check anything
        # if it is already checked, indicated by # CHECKED: badCommand
        # than we do not need to check anything either
        # if there are more than one checked command, all should be
        # mentioned in one following line
        if (not (lines[lineNumber].lstrip().startswith(TEXCOMMENT)
                 or (len(lines) > lineNumber + 1 and
                     (lines[lineNumber+1].lstrip().startswith(TEXCOMMENT)
                         and CHECKED in lines[lineNumber+1]
                         and badCommand in lines[lineNumber+1]
                         )
                     )
                 )
            ):
            if badCommand in [r"\Big", r"\big", r"\Bigg", r"\bigg"]:
                pos = findNextCommandNotAsOpt(lines[lineNumber], badCommand, 0)
            else:
                pos = findNextCommand(lines[lineNumber], badCommand, 0)
            if pos != -1:  # if found
                lines.insert(
                    lineNumber + 1,
                    getIndentation(lines[lineNumber])
                    + TEXCOMMENT + " " + TOCHECK + ": '"
                    + badCommand + "' used.\n"
                )
        lineNumber = lineNumber + 1
    return lines

def toBeReplacedCommands():
    """Return a list of commands that should be replaced."""
    return [(r"\textit", r"\undefine"),
            (r"\textbf", r"\define"),
            (r"\bigcup", r"\Union"),
            (r"\subseteq", r"⊆"),
            (r"\subset", r"⊂"),
            (r"\supseteq", r"⊇"),
            (r"\supset", r"⊃"),
            (r"\geq", r"≥"),
            (r"\leq", r"≤"),
            (r"\ge", r"≥"),
            (r"\le", r"≤"),
            # (r"\backslash", r"\setminus"),
            (r"\cap", r"∩"), # not caption
            (r"\cup", r"∪"),
            (r"\times", r"×"),
            (r"\cdot", r"·"),
            (r"\sqrt", r"√"),
            (r"\to", r"⟶"),
            (r"\Leftrightarrow", r"⇔"),
            (r"\implies", r"⇒"),
            (r"\mapsto", r"↦"),
            (r"\infty", r"∞"),
            (r"\partial", r"∂"),
            (r"\int", r"∫"),
            (r"\exists", r"∃"),
            (r"\forall", r"∀"),
            (r"\in", r"∈"),
            (r"\limits", r""), # einfach löschen
            (r"\iff", r"⇔"),
            (r"\Longleftrightarrow", r"⇔"),  # same symbol
            (r"\Rightarrow", r"⇒"),
            (r"\Longrightarrow", r"⇒"),
            (r"\Leftarrow", r"⇐"),
            (r"\Longleftarrow", r"⇐"),
            (r"\ldots", r"…"),
            (r"\dots", r"…"),
            (r"\emptyset", r"∅"),
            (r"\varnothing", r"∅"),
            (r"\N", r"ℕ"),
            (r"\R", r"ℝ"),
            (r"\Q", r"ℚ"),
            (r"\circ", r"∘"),
            (r"\land", r"∧"),
            (r"\wedge", r"∧"),
            (r"\ss ", r"ß"),
            (r"\ss", r"ß"),
            (r"\alpha", r"α"),
            (r"\beta", r"β"),
            (r"\gamma", r"γ"),
            (r"\Gamma", r"Γ"),
            (r"\lambda", r"λ"),
            (r"\sigma", r"σ"),
            (r"\delta", r"δ"),
            (r"\Delta", r"Δ"),
            (r"\xi", r"ζ"),
            (r"\mu", r"μ"),
            (r"\omega", r"ω"),
            (r"\Omega", r"Ω"),
            (r"\varepsilon", r"ε"),
            (r"\varphi", r"φ"),
            (r"\tau", r"τ"),
            (r"\vartheta", r"ϑ"),
            (r"\psi", r"ψ"),
            (r"\nu", r"ν"),
            (r"\Phi", r"Φ"),
            (r"\kappa", r"κ"),
            (r"\pi", r"π"),
            (r"\theta", r"θ"),
            (r"\Theta", r"Θ"),
            (r"\mathcal{S}", r"\S"),
            (r"\mathcal{L}", r"\L"),
            (r"\stackrel", r"\overset"),
            (r"\E\eckigeKlammern", r"\Earg"),
            (r"\E \eckigeKlammern", r"\Earg")
            # (r"\overline", r"\abschluss")  # not always useful
        ]

def warningTriggeringCommands():
    """Return a list of commands that are fishy."""
    return [r"\backslash", #, r"\setminus"),
            r"\glqq ", # r"„"),
            r" \\grqq", # r"“"),
            r"\glqq", # r"„"),
            r"\grqq", #r"“"),
            r'"',
            r"``",
            r"''",
            r"\rightarrow", # r"⟶"),
            r"\Longleftrightarrow", # r"⇔"),
            # r"\longrightarrow", #r"⟶"),  # is far more often correct than
            # wrong
            r"\Leftrightarrow", #r"⇔"),
            r"\leftbrace", #r"\{"),
            r"\rightbrace", #r"\}"),
            r"\lbrace", #r"\{"),
            r"\rbrace", #r"\}"),
            r"\lfloor",
            r"\rfloor",
            r"\rceil",
            r"\lceil",
            r"\mathbb{N}", #r"ℕ"),
            r"\mathbb{R}", #r"ℝ"),
            r"\mathbb{Q}", #r"ℝ"),
            r"\mathrm", # r"\text"),
            r"\Big",
            r"\big",
            r"\Bigg",
            r"\bigg",
            r"|",  # often abs is meant
            r"z.B.",
            r"z. B.",
            r"i.i.d.",
            r"\underline",
            r"\ul",
            r"d.h.",
            r"D.h.",
            r"D. h.",
            r"d. h.",
            r"bzw.",
            r"f.s.",
            r"\nl",
            r"o.B.d.A.",
            r"\abschluss",  # probably just created
            r"\left",
            r"\right", # e.g. stay in code in nested \left \right blocks
            r"\langle",
            r"\rangle",
            r"\Vert",
            r"\lVert",
            r"\rVert",
            r"^°" # probably \inner is better
            ]

def bracketPairs():
    """Return a list of bracket pairs and maxArgLens and their replacement."""
    return [(r"\left|", r"\right|", 15, r"\abs{", r"}"),
            (r"\big|", r"\big|", 15, r"\abs[\big]{", r"}"),
            (r"\Big|", r"\Big|", 15, r"\abs[\Big]{", r"}"),
            ("|", "|", 15, r"\abs{", r"}"),
            (r"\big\Vert", r"\big\Vert", 20, r"\norm[\big]{", "}"),
            (r"\Big\Vert", r"\Big\Vert", 20, r"\norm[\Big]{", "}"),
            (r"\Vert", r"\Vert", 20, r"\norm{", "}"),
            (r"\Big(", r"\Big)", 20, r"\klammern[\Big]{", "}"),
            (r"\big(", r"\big)", 20, r"\klammern[\big]{", "}"),
            (r"\E[", r"]", 20, r"\Earg{", "}"),
            (r"\Earg\left[", r"\right]", 20, r"\Earg{", "}"),
            (r"\E\Big[", r"\Big]", 20, r"\Earg[\Big]{", "}"),
            (r"\E\big[", r"\big]", 20, r"\Earg[\big]{", "}"),
            (r"\Big[", r"\Big]", 20, r"\eckigeKlammern[\Big]{", "}"),
            (r"\big[", r"\big]", 20, r"\eckigeKlammern[\big]{", "}"),
            (r"\left(", r"\right)", 20, r"\klammern{", "}"),
            (r"\big\lbrace", r"\big\rbrace", 60, r"\set[\big]{", "}"),
            (r"\Big\lbrace", r"\Big\rbrace", 60, r"\set[\Big]{", "}"),
            (r"\bigg\lbrace", r"\bigg\rbrace", 60, r"\set[\bigg]{", "}"),
            (r"\Bigg\lbrace", r"\Beigg\rbrace", 60, r"\set[\Bigg]{", "}"),
            (r"\left\lbrace", r"\right\rbrace", 60, r"\set{", "}"),
            (r"\lbrace", r"\rbrace", 60, r"\set{", "}"),
            (r"\lfloor", r"\rfloor", 20, r"\floor{", "}"),
            (r"\lceil", r"\rceil", 20, r"\ceil{", "}"),
            # \langle, \rangle does not work since its a paired delimiter
            # we had to guess the middle as well
            (r"``", r"''", 30, r"\enquote{", r"}"),
            (r"\E[", r"]", 5, r"\Earg{", "}"),
            (r"\E [", r"]", 5, r"\Earg{", "}")
           ]


def getIndentation(text):
    """Get the leading whitespace of a string."""
    for i in range(len(text)):
        if not text[i].isspace():
            return text[:i]

def getReplacePairs():
    """Give a list of pairs of what should be replaced.

    First entry: to be removed.
    Second entry: new text.

    Difference to replaced commands: letters are allowed to follow.

    """
    return [
        ("z.B. ", r"z.\,B.\ "),
        ("z.B.:", r"z.\,B.:"),
        ("z. B. ", r"z.\,B.\ "),
        ("z. B.:", r"z.\,B.:"),
        ("i.i.d. ", r"\iid\ "),
        ("d.h. ", r"d.\,h.\ "),
        ("D.h. ", r"D.\,h.\ "),
        ("d. h. ", r"d.\,h.\ "),
        ("D. h. ", r"D.\,h.\ "),
        ("d.h.:", r"d.\,h.:"),
        ("d. h.:", r"d.\,h.:"),
        ("u.a.:", r"u.\,a.:"),
        ("u. a.:", r"u.\,a.:"),
        ("u.a. ", r"u.\,a\ "),
        ("u. a. ", r"u.\,a.\ "),
        ("i.A. ", r"i.\,A.\ "),
        ("i. A. ", r"i.\,A.\ "),
        ("o.B.d.A. ", r"o.\,B.\,d.\,A.\ "),
        ("bzw. ", "bzw.\ "),
        (r"\mathcal{S}", r"\S "),
        (r"\mathcal{L}", r"\L "),
        (r"\stackrelnew{w}{}{\longrightarrow}", r"\weakto "),
        (r"\stackrelnew{w}{n → ∞}{\longrightarrow}", r"\weakto[n → ∞]"),
        (r"\overset{\L}{\longrightarrow}", r"\distrto "),
        (r"\overset{n⟶∞}{\longrightarrow}", r"\ntoinf "),
        (r"\overset{n → ∞}{\longrightarrow}", r"\ntoinf "),
        (r"\overset{n→∞}&{\longrightarrow}", r"\ntoinf[&] "),
        (r"\overset{n → ∞}&{\longrightarrow}", r"\ntoinf[&] "),
        (r"\overset{\P}{\longrightarrow}", r"\stochto"),
        (r"\mathbb{N}", "ℕ"),
        (r"\mathbb{R}", "ℝ"),
        (r"\mathbb{Q}", "ℚ"),
        (r"\mathbb{C}", "ℂ")
    ]

if __name__ == "__main__":
    textfilename = sys.argv[1]
    print("Make file", textfilename, "readable.")
    with open(textfilename, mode="r") as textfile:
        textext = textfile.read()  # read as tex-Text
        toBeReplacedWithoutArgument = toBeReplacedCommands()
        toBeReplacedWithoutArgumentInverse = [(item[1], item[0]) for item in toBeReplacedWithoutArgument]
        for (mySymbol, myTexText) in toBeReplacedWithoutArgumentInverse:
            textext = replaceArgumentLessCommand(textext, mySymbol,
                                                 myTexText)
        for old, new in [(item[1],item[0]) for item in getReplacePairs()]:
            textext = textext.replace(old, new)
        texlines = textext.splitlines(keepends=True)
        
    with open(textfilename + "_changed", mode="w") as textfile:
        textfile.writelines(texlines)

