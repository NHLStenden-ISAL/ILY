namespace ILY.CodeElements; 

public class ConstantExpressionElement : ICodeElement {
	public ICodeElement Parent { get; set; }
	public string Value { get; set; }
	
	public ConstantExpressionElement(ICodeElement parent, string value) {
		this.Parent = parent;
		this.Value = value;
	}
	
	public void Accept(ICodeElementVisitor visitor) {
		visitor.Visit(this);
	}
}