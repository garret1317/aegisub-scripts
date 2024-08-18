#!/usr/bin/env python3
import re
import ass
import argparse
import sys
from io import StringIO
import os.path

SHENAN_PATTERN = re.compile("shenan ([^;]*)")

def decode_path(dialogue_path, shenan_path):
	abspath = os.path.abspath(dialogue_path)
	directory = os.path.dirname(abspath)
	path = os.path.join(directory, shenan_path)
	return path

def main(sub, dialogue_path):
	imports = {}

	i = 0

	while i < len(sub):
		line = sub[i]
		if line.effect == "import":
			with open(decode_path(dialogue_path, line.text), encoding='utf-8-sig') as f:
				imported_sub = ass.parse(f)

				for imported_line in imported_sub.events:
					match = SHENAN_PATTERN.search(imported_line.effect)
					if match != None:
						name = match.group(1)
						if not name in imports:
							imports[name] = []
						imports[name].append(imported_line)

		match = SHENAN_PATTERN.search(line.effect)
		if match != None:
			name = match.group(1)
			if name in imports:
				shenans = imports[name]
				del sub[i]
				if shenans != None:
					sub = [*sub[:i], *shenans, *sub[i:]]
					i += len(shenans)
					imports[name] = None
				i -= 1

		i += 1
	return sub

def insert_shenanigans(infile, outfile):
	doc = ass.parse(infile)
	doc.events = main(doc.events, infile.name)
	doc.dump_file(outfile)

def insert_inplace(fi):
	with open(fi, "r", encoding='utf-8-sig') as f:
		doc = ass.parse(f)
		doc.events = main(doc.events, f.name)
	with open(fi, "w", encoding='utf-8-sig') as f:
		doc.dump_file(f)

if __name__ == "__main__":
	parser = argparse.ArgumentParser(description=('Shenanigan script'))

	parser.add_argument('input', type=argparse.FileType('r', encoding='utf-8-sig'))
	parser.add_argument('output', type=argparse.FileType('w', encoding='utf-8-sig'), nargs="?", default=sys.stdout)

	args = parser.parse_args()

	insert_shenanigans(args.input, args.output)
