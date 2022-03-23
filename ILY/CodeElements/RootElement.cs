namespace ILY.CodeElements; 

public class RootElement : ICodeElement {
	private readonly List<ICodeElement> _children;

	public RootElement() {
		this._children = new List<ICodeElement>();
	}

	public void AddChild(ICodeElement child, int position) {
		this._children.Insert(position, child);
	}

	public void RemoveChild(ICodeElement child) {
		this._children.Remove(child);
	}

	public IReadOnlyList<ICodeElement> GetChildren() {
		return this._children;
	}

	public void Accept(ICodeElementVisitor visitor) {
		visitor.Visit(this);
	}
}