---

name: text-statistics
description: Analyze a text input and return basic statistics such as character count, word count, line count, and frequency of top words. Use when the user asks for text analysis or statistics.
license: MIT
metadata:
  author: demo
  version: "0.1"

---

## Purpose

This skill analyzes plain text and produces basic statistics that are commonly requested in text processing tasks.

Use this skill when:
- The user provides a block of text and asks for analysis
- The user asks for counts (words, characters, lines)
- The user asks for simple frequency statistics

---

## Inputs

- **Text**: any UTF-8 plain text provided by the user

---

## Outputs

Return a structured result containing:

- Total number of characters (including spaces)
- Total number of words (split by whitespace)
- Total number of lines
- Top 5 most frequent words (case-insensitive)

---

## Procedure

1. Read the full input text as a single string.
2. Count characters using the raw string length.
3. Split text by newline characters to count lines.
4. Normalize text to lowercase.
5. Split by whitespace to extract words.
6. Count word frequency.
7. Sort by frequency in descending order.
8. Return the result in a clear, human-readable format.

---

## Example

**Input:**

Hello world
 Hello agent

**Output:**

Characters: 23
 Lines: 2
 Words: 4
 Top words:

- hello: 2
- world: 1
- agent: 1

---

## Notes

- Punctuation may be treated as part of a word unless explicitly removed.
- Do not perform language-specific tokenization.
- This skill does not modify or rewrite the text.