package toon;

import java.sql.Timestamp;


public class WriterBean {

	private int num;
    private String writerId; //작가 아이디
    private String writerName; // 작가 이름
    private String workName; //작품 명
    private String titleImage;// 작품 대표 이미지
    private String synop; // 시놉시스
    private String genre; //장르
    private Timestamp writeStart; //첫 연재일
    private int writeWeek; //연재 요일 일월화수목금토일 : 0123456
    private int writeEnd; // 연재 종료 여부 0: no 1: yes
    private int viewMode; // 작품 공개 여부 0: 공개 1: 비공개
	private int liked; // 추천 수


    public WriterBean(int num, String writerId, String writerName, String workName, String titleImage, String synop,
			String genre, Timestamp writeStart, int writeWeek, int writeEnd, int viewMode, int liked) {
		super();
		this.num = num;
		this.writerId = writerId;
		this.writerName = writerName;
		this.workName = workName;
		this.titleImage = titleImage;
		this.synop = synop;
		this.genre = genre;
		this.writeStart = writeStart;
		this.writeWeek = writeWeek;
		this.writeEnd = writeEnd;
		this.viewMode = viewMode;
		this.liked = liked;
	}

	public WriterBean(){
    	
    }
    
	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	public String getWriterId() {
		return writerId;
	}

	public void setWriterId(String writerId) {
		this.writerId = writerId;
	}

	public String getWriterName() {
		return writerName;
	}

	public void setWriterName(String writerName) {
		this.writerName = writerName;
	}

	public String getWorkName() {
		return workName;
	}

	public void setWorkName(String workName) {
		this.workName = workName;
	}

	public String getTitleImage() {
		return titleImage;
	}

	public void setTitleImage(String titleImage) {
		this.titleImage = titleImage;
	}

	public String getSynop() {
		return synop;
	}

	public void setSynop(String synop) {
		this.synop = synop;
	}

	public String getGenre() {
		return genre;
	}

	public void setGenre(String genre) {
		this.genre = genre;
	}

	public Timestamp getWriteStart() {
		return writeStart;
	}

	public void setWriteStart(Timestamp writeStart) {
		this.writeStart = writeStart;
	}

	public int getWriteWeek() {
		return writeWeek;
	}

	public void setWriteWeek(int writeWeek) {
		this.writeWeek = writeWeek;
	}
	
	public int getWriteEnd() {
		return writeEnd;
	}

	public void setWriteEnd(int writeEnd) {
		this.writeEnd = writeEnd;
	}

	public int getViewMode() {
		return viewMode;
	}

	public void setViewMode(int viewMode) {
		this.viewMode = viewMode;
	}

	public int getLiked() {
		return liked;
	}

	public void setLiked(int liked) {
		this.liked = liked;
	}
	
}
