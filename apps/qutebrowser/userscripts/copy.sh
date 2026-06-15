#!/usr/bin/env bash

python3 -c '
import sys, re
from html.parser import HTMLParser

class AIParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.fed = []
        self.ignore = False
    def handle_starttag(self, tag, attrs):
        if tag in ["script", "style", "nav", "footer", "header", "aside"]: 
            self.ignore = True
    def handle_endtag(self, tag):
        if tag in ["script", "style", "nav", "footer", "header", "aside"]: 
            self.ignore = False
    def handle_data(self, d):
        if not self.ignore: 
            self.fed.append(d)
    def get_data(self):
        return "".join(self.fed)

with open(sys.argv[1], "r", encoding="utf-8", errors="ignore") as f:
    parser = AIParser()
    parser.feed(f.read())
    text = parser.get_data()
    text = re.sub(r"\n\s*\n", "\n\n", text)
    text = re.sub(r"[ \t]+", " ", text)
    print(text.strip())
' "$QUTE_HTML" | wl-copy && notify-send "Content copy"
