import * as vscode from "vscode";
import { hoverText } from "./hovertext";
import * as fs from "fs";
import * as path from "path";

export function activate(context: vscode.ExtensionContext) {
  const reference_path = context.asAbsolutePath(
    path.join("resources", "reference.json")
  );
  const reference_data = JSON.parse(fs.readFileSync(reference_path, "utf8"));

  vscode.languages.registerHoverProvider("niosii", {
    provideHover(document, position, _token) {
      const line = document.lineAt(position.line);

      // do not hover in what is obviously a comment
      const commentStart = line.text.search(/(\/\/)|(\#)/);
      console;
      if (commentStart != -1 && commentStart < position.character) {
        return null;
      }

      const range = document.getWordRangeAtPosition(position);
      let word = document.getText(range);

      // include leading "." for directives such as `.section`
      const before = range?.start.with(
        range.start.line,
        range.start.character - 1
      );
      if (before !== undefined) {
        const rangeBefore = range?.with(before, range.start);
        if (rangeBefore !== undefined) {
          const textBefore = document.getText(rangeBefore);
          if (textBefore == ".") {
            word = "." + word;
          }
        }
      }

      const text = hoverText(reference_data, word);
      return text === null
        ? null
        : {
            contents: [text],
          };
    },
  });
}
