using ILY.CodeElements;

namespace ILY; 

public class CompilationUnit {
	private readonly RootElement _rootElement;
	
	public CompilationUnit() {
		this._rootElement = new RootElement();
	}

	public FunctionElement CreateFunction(string identifier, int position) {
		var functionElement = new FunctionElement(this._rootElement, identifier);
		this._rootElement.AddChild(functionElement, position);

		return functionElement;
	}

	public StructElement CreateStruct(string identifier, int position) {
		var structElement = new StructElement(this._rootElement, identifier);
		this._rootElement.AddChild(structElement, position);

		return structElement;
	}

	public FieldElement CreateField(StructElement parent, string identifier, string type, int position) {
		var fieldElement = new FieldElement(parent, identifier, type);
		parent.AddField(fieldElement, position);

		return fieldElement;
	}

	public ArgumentElement CreateArgument(FunctionElement parent, string identifier, string type, int position) {
		var argumentElement = new ArgumentElement(parent, identifier, type);
		parent.AddArgument(argumentElement, position);

		return argumentElement;
	}
	
	public VariableDeclarationElement CreateVariableDeclaration(FunctionElement parent, string identifier, string type,
		int position) {
		var variableDeclarationElement = new VariableDeclarationElement(parent, identifier, type);
		parent.AddStatement(variableDeclarationElement, position);

		return variableDeclarationElement;
	}

	public ConstantExpressionElement CreateConstantExpressionElement(VariableDeclarationElement parent, string value) {
		var constantExpressionElement = new ConstantExpressionElement(parent, value);
		parent.SetExpression(constantExpressionElement);

		return constantExpressionElement;
	}
	
	public ConstantExpressionElement CreateConstantExpressionElement(ReturnElement parent, string value) {
		var constantExpressionElement = new ConstantExpressionElement(parent, value);
		parent.SetExpression(constantExpressionElement);

		return constantExpressionElement;
	}
	
	public ConstantExpressionElement CreateConstantExpressionElementLeft(BinaryExpressionElement parent, string value) {
		var constantExpressionElement = new ConstantExpressionElement(parent, value);
		parent.SetLeft(constantExpressionElement);

		return constantExpressionElement;
	}
	
	public ConstantExpressionElement CreateConstantExpressionElementRight(BinaryExpressionElement parent, string value) {
		var constantExpressionElement = new ConstantExpressionElement(parent, value);
		parent.SetRight(constantExpressionElement);

		return constantExpressionElement;
	}
	
	public FunctionCallElement CreateFunctionCallElementLeft(BinaryExpressionElement parent, string identifier) {
		var functionCallElement = new FunctionCallElement(parent, identifier);
		parent.SetLeft(functionCallElement);

		return functionCallElement;
	}
	
	public FunctionCallElement CreateFunctionCallElementRight(BinaryExpressionElement parent, string identifier) {
		var functionCallElement = new FunctionCallElement(parent, identifier);
		parent.SetRight(functionCallElement);

		return functionCallElement;
	}
	
	public BinaryExpressionElement CreateBinaryExpressionElement(VariableDeclarationElement parent, string operation) {
		var binaryExpressionElement = new BinaryExpressionElement(parent, operation);
		parent.SetExpression(binaryExpressionElement);

		return binaryExpressionElement;
	}
	
	public BinaryExpressionElement CreateBinaryExpressionElement(IfElement parent, string operation) {
		var binaryExpressionElement = new BinaryExpressionElement(parent, operation);
		parent.SetExpression(binaryExpressionElement);

		return binaryExpressionElement;
	}

	public BinaryExpressionElement CreateBinaryExpressionElement(ReturnElement parent, string operation) {
		var binaryExpressionElement = new BinaryExpressionElement(parent, operation);
		parent.SetExpression(binaryExpressionElement);

		return binaryExpressionElement;
	}
	
	public BinaryExpressionElement CreateBinaryExpressionElement(FunctionCallElement parent, string operation, int position) {
		var binaryExpressionElement = new BinaryExpressionElement(parent, operation);
		parent.AddArgument(binaryExpressionElement, position);

		return binaryExpressionElement;
	}

	public IfElement CreateIfElement(FunctionElement parent, int position) {
		var ifElement = new IfElement(parent);
		parent.AddStatement(ifElement, position);

		return ifElement;
	}
	
	public IfElement CreateIfElement(IfElement parent, int position) {
		var ifElement = new IfElement(parent);
		parent.AddStatement(ifElement, position);

		return ifElement;
	}
	
	public ReturnElement CreateReturnElement(FunctionElement parent, int position) {
		var returnElement = new ReturnElement(parent);
		parent.AddStatement(returnElement, position);

		return returnElement;
	}

	public ReturnElement CreateReturnElement(IfElement parent, int position) {
		var returnElement = new ReturnElement(parent);
		parent.AddStatement(returnElement, position);

		return returnElement;
	}
	
	public void Visit(ICodeElementVisitor visitor) {
		this._rootElement.Accept(visitor);
	}
}