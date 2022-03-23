using ILY.CodeElements;
using ILY.Theme;
using Love;
using Timer = Love.Timer;

namespace ILY; 

public class EditorWindow : Scene {
	private class CodeElementRenderer : ICodeElementVisitor {
		private readonly List<TextElement> _textElements;
		
		private readonly Font _font;
		private readonly ITheme _theme;
		
		private Vector2 _cursor;
		private int _indentation;

		public CodeElementRenderer(List<TextElement> textElements, Font font, ITheme theme) {
			this._textElements = textElements;
			
			this._font = font;
			this._theme = theme;
			
			this._cursor = new Vector2(0, 0);
			this._indentation = 0;
		}
		
		public void Visit(RootElement rootElement) {
			foreach (var child in rootElement.GetChildren()) {
				child.Accept(this);
				this.NewLine();
			}
		}

		public void Visit(StructElement structElement) {
			this.Print("struct", this._theme.Syntax.KeywordStructColor);
			this.Space();
			this.Print(structElement.Identifier, this._theme.Syntax.IdentifierColor);
			this.Space();
			this.Print("{", this._theme.Syntax.TextColor);
			this.NewLine();
			this.Indent();
			foreach (var field in structElement.GetFields()) {
				field.Accept(this);
			}
			this.Outdent();
			this.Print("}", this._theme.Syntax.TextColor);
			this.NewLine();
		}
		
		public void Visit(FunctionElement functionElement) {
			this.Print("function", this._theme.Syntax.KeywordFunctionColor);
			this.Space();
			this.Print(functionElement.Identifier, this._theme.Syntax.IdentifierColor);
			this.Print("(", this._theme.Syntax.TextColor);
			foreach (var argument in functionElement.GetArguments()) {
				argument.Accept(this);
				
				if (argument != functionElement.GetArguments().Last()) {
					this.Print(",", this._theme.Syntax.TextColor);
					this.Space();
				}
			}
			this.Print(")", this._theme.Syntax.TextColor);
			this.Space();
			this.Print("{", this._theme.Syntax.TextColor);
			this.NewLine();
			this.Indent();
			foreach (var statement in functionElement.GetStatements()) {
				statement.Accept(this);
				
				if (statement != functionElement.GetStatements().Last())
					this.NewLine();
			}
			this.Outdent();
			this.Print("}", this._theme.Syntax.TextColor);
			this.NewLine();
		}

		public void Visit(FieldElement fieldElement) {
			this.Print(fieldElement.Identifier, this._theme.Syntax.FieldColor);
			this.Space();
			this.Print(":", this._theme.Syntax.TextColor);
			this.Space();
			this.Print(fieldElement.Type, this._theme.Syntax.TypeColor);
			this.Print(";", this._theme.Syntax.TextColor);
			this.Space();
			this.NewLine();
		}
		
		public void Visit(ArgumentElement argumentElement) {
			this.Print(argumentElement.Identifier, this._theme.Syntax.VariableColor);
			this.Space();
			this.Print(":", this._theme.Syntax.TextColor);
			this.Space();
			this.Print(argumentElement.Type, this._theme.Syntax.TypeColor);
		}
		
		public void Visit(VariableDeclarationElement variableDeclarationElement) {
			this.Print("var", this._theme.Syntax.KeywordVarColor);
			this.Space();
			this.Print(variableDeclarationElement.Identifier, this._theme.Syntax.VariableColor);
			this.Space();
			this.Print(":", this._theme.Syntax.TextColor);
			this.Space();
			this.Print(variableDeclarationElement.Type, this._theme.Syntax.TypeColor);
			if (variableDeclarationElement.Expression != null) {
				this.Space();
				this.Print("=", this._theme.Syntax.TextColor);
				this.Space();
				variableDeclarationElement.Expression.Accept(this);
			}
			this.Print(";", this._theme.Syntax.TextColor);
			this.NewLine();
		}
		
		public void Visit(BinaryExpressionElement binaryExpressionElement) {
			binaryExpressionElement.Left.Accept(this);
			this.Space();
			this.Print(binaryExpressionElement.Operation, this._theme.Syntax.TextColor);
			this.Space();
			binaryExpressionElement.Right.Accept(this);
		}
		
		public void Visit(ConstantExpressionElement constantExpressionElement) {
			var color = this._theme.Syntax.ConstantStringColor;

			if (bool.TryParse(constantExpressionElement.Value, out _)) {
				color = this._theme.Syntax.ConstantBooleanColor;
			}
			
			if (double.TryParse(constantExpressionElement.Value, out _)) {
				color = this._theme.Syntax.ConstantNumberColor;
			}
			
			this.Print(constantExpressionElement.Value, color);
		}

		public void Visit(IfElement ifElement) {
			this.Print("if", this._theme.Syntax.KeywordFunctionColor);
			this.Space();
			this.Print("(", this._theme.Syntax.TextColor);
			ifElement.Expression.Accept(this);
			this.Print(")", this._theme.Syntax.TextColor);
			this.Space();
			this.Print("{", this._theme.Syntax.TextColor);
			this.NewLine();
			this.Indent();
			foreach (var statement in ifElement.GetStatements()) {
				statement.Accept(this);
				
				if (statement != ifElement.GetStatements().Last())
					this.NewLine();
			}
			this.Outdent();
			this.Print("}", this._theme.Syntax.TextColor);
			this.NewLine();
		}
		
		public void Visit(ReturnElement returnElement) {
			this.Print("return", this._theme.Syntax.KeywordReturnColor);
			this.Space();
			returnElement.Expression.Accept(this);
			this.Print(";", this._theme.Syntax.TextColor);
			this.NewLine();
		}
		
		public void Visit(FunctionCallElement functionCallElement) {
			this.Print(functionCallElement.Identifier, this._theme.Syntax.IdentifierColor);
			this.Print("(", this._theme.Syntax.TextColor);
			foreach (var argument in functionCallElement.GetArguments()) {
				argument.Accept(this);

				if (argument != functionCallElement.GetArguments().Last()) {
					this.Print(",", this._theme.Syntax.TextColor);
					this.Space();
				}
			}
			this.Print(")", this._theme.Syntax.TextColor);
		}
		
		private void Print(string text, Color color) {
			var position = this._cursor;
			position.X += this._indentation * this._font.GetWidth(" ") * 4;
			
			var textElement = new TextElement(text, position, color);
			this._textElements.Add(textElement);
			
			this._cursor.X += this._font.GetWidth(text);
		}

		private void NewLine() {
			this._cursor.X = 0;
			this._cursor.Y += this._font.GetHeight();
		}

		private void Space() {
			this._cursor.X += this._font.GetWidth(" ");
		}

		private void Indent() {
			this._indentation++;
		}

		private void Outdent() {
			this._indentation--;
		}
	}
	
	private readonly ThemeProvider _themeProvider;

	private readonly CompilationUnit _compilationUnit;
	
	public EditorWindow() {
		var font = Graphics.NewFont("Assets/FiraCode-Regular.ttf", 24);
		Graphics.SetFont(font);
		
		this._themeProvider = new ThemeProvider();

		this._compilationUnit = new CompilationUnit();

		var fibFunction = this._compilationUnit.CreateFunction("fib", 0);
		this._compilationUnit.CreateArgument(fibFunction, "n", "number", 0);

		var ifZero = this._compilationUnit.CreateIfElement(fibFunction, 0);
		var nIsZeroExpression = this._compilationUnit.CreateBinaryExpressionElement(ifZero, "==");
		this._compilationUnit.CreateConstantExpressionElementLeft(nIsZeroExpression, "n");
		this._compilationUnit.CreateConstantExpressionElementRight(nIsZeroExpression, "0");

		var returnIfZero = this._compilationUnit.CreateReturnElement(ifZero, 0);
		this._compilationUnit.CreateConstantExpressionElement(returnIfZero, "1");
		
		var ifOne = this._compilationUnit.CreateIfElement(fibFunction, 1);
		var nIsOneExpression = this._compilationUnit.CreateBinaryExpressionElement(ifOne, "==");
		this._compilationUnit.CreateConstantExpressionElementLeft(nIsOneExpression, "n");
		this._compilationUnit.CreateConstantExpressionElementRight(nIsOneExpression, "1");
		
		var returnIfOne = this._compilationUnit.CreateReturnElement(ifOne, 0);
		this._compilationUnit.CreateConstantExpressionElement(returnIfOne, "1");


		var returnResult = this._compilationUnit.CreateReturnElement(fibFunction, 2);
		var resultExpression = this._compilationUnit.CreateBinaryExpressionElement(returnResult, "+");
		var resultFibLeft = this._compilationUnit.CreateFunctionCallElementLeft(resultExpression, "fib");
		var resultFibRight = this._compilationUnit.CreateFunctionCallElementRight(resultExpression, "fib");

		var resultFibLeftExpr = this._compilationUnit.CreateBinaryExpressionElement(resultFibLeft, "-", 0);
		this._compilationUnit.CreateConstantExpressionElementLeft(resultFibLeftExpr, "n");
		this._compilationUnit.CreateConstantExpressionElementRight(resultFibLeftExpr, "1");
		
		var resultFibRightExpr = this._compilationUnit.CreateBinaryExpressionElement(resultFibRight, "-", 0);
		this._compilationUnit.CreateConstantExpressionElementLeft(resultFibRightExpr, "n");
		this._compilationUnit.CreateConstantExpressionElementRight(resultFibRightExpr, "2");
	}

	public override void Draw() {
		Graphics.Clear(this._themeProvider.CurrentTheme.BackgroundColor);
		Graphics.Push(StackType.All);
		Graphics.Translate(600, 50);

		var textElements = new List<TextElement>();
		var codeElementRenderer = new CodeElementRenderer(textElements, Graphics.GetFont(), this._themeProvider.CurrentTheme);
		this._compilationUnit.Visit(codeElementRenderer);

		foreach (var textElement in textElements) {
			Graphics.SetColor(textElement.Color);
			Graphics.Print(textElement.Text, textElement.Position.X, textElement.Position.Y);
		}

		Graphics.Pop();
		
		Graphics.Print(Timer.GetFPS().ToString());
	}
}