namespace ILY.CodeElements; 

public interface ICodeElement {
	public void Accept(ICodeElementVisitor visitor);
}