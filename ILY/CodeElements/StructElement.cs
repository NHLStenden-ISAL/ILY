namespace ILY.CodeElements; 

public class StructElement : ICodeElement {
	private readonly List<ICodeElement> _fields;
	
	public ICodeElement Parent { get; set; }
	public string Identifier { get; set; }

	public StructElement(ICodeElement parent, string identifier) {
		this._fields = new List<ICodeElement>();
		
		this.Parent = parent;
		this.Identifier = identifier;
	}
	
	public void AddField(ICodeElement field, int position) {
		this._fields.Insert(position, field);
	}

	public void RemoveField(ICodeElement child) {
		this._fields.Remove(child);
	}

	public IReadOnlyList<ICodeElement> GetFields() {
		return this._fields;
	}
	
	public void Accept(ICodeElementVisitor visitor) {
		visitor.Visit(this);
	}
}