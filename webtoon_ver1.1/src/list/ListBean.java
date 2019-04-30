package list;

import java.sql.Timestamp;

public class ListBean {
	private int num;
	private String listType;
	private String whatcontents;
	private String img;
	private String writerId;
	private String writerName;
	private String subject;
	private String content;
	private Timestamp reg_date;
	private int readcount;
	private int ref;
	private int re_step;
	private int re_level;
	private int liked;
	
	public ListBean(){
		
	}
	
	public ListBean(int num, String listType, String whatcontents, String img, String writerId, String writerName, String subject,
			String content, Timestamp reg_date, int readcount, int ref, int re_step, int re_level, int liked) {
		super();
		this.num = num;
		this.listType = listType;
		this.whatcontents = whatcontents;
		this.img = img;
		this.writerId = writerId;
		this.writerName = writerName;
		this.subject = subject;
		this.content = content;
		this.reg_date = reg_date;
		this.readcount = readcount;
		this.ref = ref;
		this.re_step = re_step;
		this.re_level = re_level;
		this.liked = liked;
	}
	
	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	public String getListType() {
		return listType;
	}

	public void setListType(String listType) {
		this.listType = listType;
	}

	public String getWhatcontents() {
		return whatcontents;
	}

	public void setWhatcontents(String whatcontents) {
		this.whatcontents = whatcontents;
	}

	public String getImg() {
		return img;
	}

	public void setImg(String img) {
		this.img = img;
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

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Timestamp getReg_date() {
		return reg_date;
	}

	public void setReg_date(Timestamp reg_date) {
		this.reg_date = reg_date;
	}

	public int getReadcount() {
		return readcount;
	}

	public void setReadcount(int readcount) {
		this.readcount = readcount;
	}

	public int getRef() {
		return ref;
	}

	public void setRef(int ref) {
		this.ref = ref;
	}

	public int getRe_step() {
		return re_step;
	}

	public void setRe_step(int re_step) {
		this.re_step = re_step;
	}

	public int getRe_level() {
		return re_level;
	}

	public void setRe_level(int re_level) {
		this.re_level = re_level;
	}

	public int getLiked() {
		return liked;
	}

	public void setLiked(int liked) {
		this.liked = liked;
	}
	
}
