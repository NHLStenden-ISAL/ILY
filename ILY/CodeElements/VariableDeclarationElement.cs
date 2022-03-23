namespace ILY.CodeElements; 

public class VariableDeclarationElement : ICodeElement {
	public ICodeElement Parent { get; set; }
	public string Identifier { get; set; }
	public string Type { get; set; }
	public ICodeElement? Expression { get; set; }

	public VariableDeclarationElement(ICodeElement parent, string identifier, string type) {
		this.Parent = parent;
		this.Identifier = identifier;
		this.Type = type;
	}

	public void SetExpression(ICodeElement expression) {
		this.Expression = expression;
	}
	
	public void Accept(ICodeElementVisitor visitor) {
		visitor.Visit(this);
	}
}