// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import 'vscode';
import {
  commands,
  DocumentSelector,
  ExtensionContext,
  InputBoxOptions,
  StatusBarAlignment,
  window,
} from 'vscode';

/**
 * this method is called when your extension is activate.
 * your extension is activated the very first time the command is executed.
 *
 * @param context the current context of the extension.
 */
export function activate(context: ExtensionContext) {
  const selector: DocumentSelector = [
    {
      scheme: 'file',
      language: 'NiosII',
    },
    {
      scheme: 'file',
      language: 'niosii',
    },
  ];

  // Status Bar
  const statusBar = window.createStatusBarItem(StatusBarAlignment.Left, 0);
  statusBar.text = 'NiosII: Active';
  statusBar.show();
  statusBar.command = 'NiosII.build_index';

  context.subscriptions.push(
    commands.registerCommand('NiosII.auto_instantiate', instantiateModule),
  );

  // WIP

  /**
    Gets module name from the user, and looks up in the workspaceSymbolProvider for a match.
    Looks up the module's definition, and parses it to build the module's instance.
    @return the module's instance, assigns the default parameter values.
  */
  function instantiateModule() {
    const options: InputBoxOptions = {
      prompt: 'Enter the module name to instantiate',
      placeHolder: 'Enter the module name to instantiate',
    };

    // request the module's name from the user
    window.showInputBox(options).then(value => {
      if (!value) {
        return;
      }
      // current editor
      const editor = window.activeTextEditor;

      // check if there is no selection
      if (editor.selection.isEmpty) {
        if (editor) {
          moduleInstantiator.auto_instantiate(value).then(
            function(v) {
              editor.edit(editBuilder => {
                editBuilder.replace(editor.selection, v);
              });
            },
            function(e) {
              window.showErrorMessage(e);
            },
          );
        }
      }
    });
  }
}

/**
 * this method is called when your extension is deactivated
 */
export function deactivate() {}
