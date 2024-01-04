examples = [{
    "input": """
GRFH-125
# GRIDFIN

The GRFN provides both drag and steering ability to a
craft, It is a very intentional part and was in no way
inspired by a faulty airbrake

WiStatiatics

Mass
0.080t

Max Temp

1000 K

*Impact Tolerance
15 m/s

(GIFT). view Lose G srovonste

""",
    "output": {
        "Part Name": "GRFN-125",
        "Name": "GRIDFIN",
        "Description": "The GRIDFIN provides both drag and steering ability to a craft. It is a very intentional part and was in no way inspired by a faulty airbrake.",
        "Specifications": {"Mass": "0.080t", "Max Temperature": "1000 K", "Impact Tolerance": "15 m/s"}
    }
},{
    "input": """
    “ALLR.B.R.A.K.E.S.

y DEPLOVABLE DRAG CONTROL
SURFACE

After numerous requests from Kerbal
pilots to slow a plane down, C7
created a part that replicates a
shoddily-welded hull on demand. Focus
group testing continues in order to ~

WiStatiatics

Mass |
0.040t

Max Temp
1008 K

*Impact Tolerance
15 m/s

oe

(GiHET)- view nore
""",
    "output": {
        "Part Name": "A.I.R.B.R.A.K.E.S.",
        "Name": "DEPLOYABLE DRAG CONTROL SURFACE",
        "Description": "After numerous requests from "
            "Kerbal pilots to slow a plane down, C7 created a part that "
            "replicates a shoddily-welded hull on demand. Focus group "
            "testing continues in order to improve it.",
        "Specifications": {"Impact Tolerance": "15 m/s", "Mass": "0.040t", "Max Temperature": "1000 K"}
    }
},{
    "input": """
GRFH-258 pe
# GRIDFIN

The GRFN-258 is designed to help booster recovery by
providing drag and some steering control. C7 insists it was
not designed as a response to recent competitor WingIt
Enterprises’ procedural engineering

WiStatiatics

Mass
0.320t

Max Temp
1000 K

*Impact Tolerance
15 m/s

(GHFT):view Lose B reverse
""",
    "output": {   
        "Description": "The GRFN-250 is designed to help booster recovery by providing drag and some steering control. C7 "
                   "insists it was not designed as a response to recent competitor WingIt Enterprises’ procedural "
                   "engineering.",
        "Name": "GRIDFIN",
        "Part Name": "GRFN-250",
        "Specifications": {"Impact Tolerance": "15 m/s", "Mass": "0.320t", "Max Temperature": "1000 K"}
    }
}]
