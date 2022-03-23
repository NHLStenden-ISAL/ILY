namespace ILY.CodeElements; 

public class ReturnElement : ICodeElement {
	public ICodeElement Parent { get; set; }
	public ICodeElement? Expression { get; set; }

	public ReturnElement(ICodeElement parent) {
		this.Parent = parent;
	}

	public void SetExpression(ICodeElement expression) {
		this.Expression = expression;
	}
	
	public void Accept(ICodeElementVisitor visitor) {
		visitor.Visit(this);
	}
}