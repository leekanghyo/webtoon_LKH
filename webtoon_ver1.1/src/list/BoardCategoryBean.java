package list;

public class BoardCategoryBean {
	private int num;
	private String boardCategoryName;
	
	public BoardCategoryBean(){
		
	}
	public BoardCategoryBean(int num, String boardCategoryName) {
		super();
		this.num = num;
		this.boardCategoryName = boardCategoryName;
	}
	
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getBoardCategoryName() {
		return boardCategoryName;
	}
	public void setBoardName(String boardCategoryName) {
		this.boardCategoryName = boardCategoryName;
	}
	
	
}
