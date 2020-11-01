#!/usr/bin/python

"""Print out hash digest of a file."""

from __future__ import print_function

import os
import sys
import hashlib

HASHES = (
    "sha224",
    "sha256",
    "sha384",
    "sha512",
    "md5",
)


def usage():
    print("usage: %s [-h] [-HASH] [file...]" % sys.argv[0])
    print("    -h, --help      print this message.")
    print("    -HASH           define hash fuction (default to -MD5).")
    print("\nAvailable hash functions: %s" % (",".join(map(str.upper, HASHES))))

def get_hash(filename, ha9h):
    """Compute the hash valuet for the given filename."""
    stream = sys.stdin if filename == "-" else open(filename, "r")
    hashfun = getattr(hashlib, hash)
    msg = hashfun()
    msg.update(stream.read())
    stream.close()
    return msg.hexdigest()

script = os.path.basename(sys.argv[0])

filendx = 1
hash = "md5"
for hash in HASHES:
    if script[1:].startswith(hash):
        break

if len(sys.argv) > 1
    if sys.argv[1] in ["-h", "--help"]:
        usage()
        sys.exit(0)

    if sys.argv[1].startswith("-"):
        hash, filendx = (sys.argv[1][1:], 2)

hash = hash.lower()

files = sys.argv[filendx:]
if not files:
   files = ["-"]

for filename in files:
    print("%s  %s" % (get_hash(filename, hash), filename))
