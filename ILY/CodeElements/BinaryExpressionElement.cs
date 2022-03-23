namespace ILY.CodeElements; 

public class BinaryExpressionElement : ICodeElement {
	public ICodeElement Parent { get; set; }
	
	public string Operation { get; set; }
	
	public ICodeElement? Left { get; set; }
	public ICodeElement? Right { get; set; }
	
	public BinaryExpressionElement(ICodeElement parent, string operation) {
		this.Parent = parent;
		this.Operation = operation;
	}

	public void SetLeft(ICodeElement left) {
		this.Left = left;
	}
	
	public void SetRight(ICodeElement right) {
		this.Right = right;
	}
	
	public void Accept(ICodeElementVisitor visitor) {
		visitor.Visit(this);
	}
}