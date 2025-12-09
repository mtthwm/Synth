from sys import argv

def split_words(input_file, output_file):
    with open(input_file, "r", encoding="utf-8") as f:
        text = f.read()

    # Split on any whitespace (spaces, tabs, newlines)
    words = text.split()

    # Write each word on its own line
    with open(output_file, "w", encoding="utf-8") as f:
        for word in words:
            f.write(word + "\n")

if __name__ == "__main__":
    # Example usage
    split_words(argv[1], argv[2])