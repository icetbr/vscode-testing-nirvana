const vscode = require('vscode');
const { Location, Position, languages: { registerDefinitionProvider },  commands: { registerCommand }, Uri: { file }, window: { showTextDocument }, ViewColumn, workspace: { openTextDocument } } = vscode;

const config = vscode.workspace.getConfiguration('testingNirvana');
const srcFolder = config.get('srcFolder', 'src');
const testFolder = config.get('testFolder', 'test');
const testSuffix = config.get('testSuffix', 'Test');
const peekFiles = '**/*.{js,ts}';

// /home/projects/src/Comments.ts => /home/projects/test/CommentsTest.ts
// /home/projects/src/Comments.js => /home/projects/test/CommentsTest.js
const getTestPath = srcDocument => srcDocument.uri.fsPath
	.replace(`/${srcFolder}/`, `/${testFolder}/`)
	.replace(/\.(\w)s$/, `${testSuffix}.$1s`);

const getTestFile = srcDocument => file(getTestPath(srcDocument));

const getLastLineWith = (string, text) => string.split('\n').findLastIndex(l => l.match(new RegExp(text)));

const getLastPositionOf = (string, text) => new Position(getLastLineWith(string, text), 0);

const getHighlighted = () => {
	const editor = vscode.window.activeTextEditor;
	let wordRange = editor.document.getWordRangeAtPosition(editor.selection.start);
	return editor.document.getText(wordRange);
};

const scrollTo = highlited => editor => {
	const pos = getLastPositionOf(editor.document.getText(), highlited);
	editor.selections = [new vscode.Selection(pos, pos)];
}

const openTestFile = shouldSplit => () => {
	const srcDocument = vscode.window.activeTextEditor.document;
	const highlited = getHighlighted(srcDocument);

	showTextDocument(getTestFile(srcDocument), { viewColumn: shouldSplit ? ViewColumn.Beside : -1 }).then(scrollTo(highlited));
}

const provideDefinition = document => openTextDocument(getTestPath(document)).then(getHighlitedLocation);
const getHighlitedLocation = document => new Location(document.uri, getLastPositionOf(document.getText(), getHighlighted()));

module.exports = {

	/** @param {vscode.ExtensionContext} context */
	activate: context => {
		context.subscriptions.push(registerCommand('testingNirvana.splitTo', openTestFile(true)));
		context.subscriptions.push(registerCommand('testingNirvana.goTo', openTestFile()));
		context.subscriptions.push(registerDefinitionProvider({ scheme: 'file', pattern: peekFiles }, { provideDefinition }));
	},
};

