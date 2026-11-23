#!/usr/bin/env python3
"""EI on-bound assistant stub. Replace `answer()` with a local model (llama.cpp / transformers, offline)."""
import sys
def answer(q: str) -> str:
    return f"[EI offline stub] you asked: {q}"
if __name__ == "__main__":
    print(answer(" ".join(sys.argv[1:]) or "hello"))
