import * as vscode from "vscode";
import { hoverText } from "./hovertext";

export function activate(context: vscode.ExtensionContext) {
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
      const word = document.getText(range);

      const text = hoverText(word);
      return text === null
        ? null
        : {
            contents: [text],
          };
    },
  });
}
