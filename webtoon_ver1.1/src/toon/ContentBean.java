package toon;

import java.sql.Timestamp;

public class ContentBean {
    private int num;
    private int workNum;
    private String writerId; //작가 아이디
    private String writerName; //작가 이름
    private String workName; //작품명
    private int episode; //작품 화수
    private String subtitle; //작품 타이틀 (소제목)
    private String descript; //작품 매화 설명
    private String writerComment; //작가 코멘트
    private String upload_img; //이미지 정보
    private Timestamp upload_date; //업로드 날짜 (오늘 기준 1~3일 전에 업로드 되었거나 수정되었으면 갱신 이미지 추가)
    private int wtcReadCount; //조회수
    private int wtcReply; //리플 수

    public ContentBean(){
    	
    }

	public ContentBean(int num, int workNum, String writerId, String writerName, String workName, int episode, String subtitle,
			String descript, String writerComment, String upload_img, Timestamp upload_date, int wtcReadCount,
			int wtcReply) {
		super();
		this.num = num;
		this.workNum = workNum;
		this.writerId = writerId;
		this.writerName = writerName;
		this.workName = workName;
		this.episode = episode;
		this.subtitle = subtitle;
		this.descript = descript;
		this.writerComment = writerComment;
		this.upload_img = upload_img;
		this.upload_date = upload_date;
		this.wtcReadCount = wtcReadCount;
		this.wtcReply = wtcReply;
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	public int getWorkNum(){
		return workNum;
	}
	
	public void setWorkNum(int workNum){
		this.workNum  = workNum;
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

	public int getEpisode() {
		return episode;
	}

	public void setEpisode(int episode) {
		this.episode = episode;
	}

	public String getSubtitle() {
		return subtitle;
	}

	public void setSubtitle(String subtitle) {
		this.subtitle = subtitle;
	}

	public String getDescript() {
		return descript;
	}

	public void setDescript(String descript) {
		this.descript = descript;
	}

	public String getWriterComment() {
		return writerComment;
	}

	public void setWriterComment(String writerComment) {
		this.writerComment = writerComment;
	}

	public String getUpload_img() {
		return upload_img;
	}

	public void setUpload_img(String upload_img) {
		this.upload_img = upload_img;
	}

	public Timestamp getUpload_date() {
		return upload_date;
	}

	public void setUpload_date(Timestamp upload_date) {
		this.upload_date = upload_date;
	}

	public int getWtcReadCount() {
		return wtcReadCount;
	}

	public void setWtcReadCount(int wtcReadCount) {
		this.wtcReadCount = wtcReadCount;
	}

	public int getWtcReply() {
		return wtcReply;
	}

	public void setWtcReply(int wtcReply) {
		this.wtcReply = wtcReply;
	}


}
