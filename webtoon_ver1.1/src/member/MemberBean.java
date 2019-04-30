package member;

import java.sql.Timestamp;

public class MemberBean {
    int num;
    String id;
    String name;
    String passwd;
    String rePasswd; //비밀번호 변경 시
    String userimg; //작가 전용
    Timestamp adddate;
    String wtmtype;
    
    public MemberBean(){
    	
    }

	public MemberBean(int num, String id, String name, String passwd, String userimg, Timestamp adddate,
			String wtmtype) {
		super();
		this.num = num;
		this.id = id;
		this.name = name;
		this.passwd = passwd;
		this.userimg = userimg;
		this.adddate = adddate;
		this.wtmtype = wtmtype;
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPasswd() {
		return passwd;
	}

	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}
	public String getRePasswd() {
		return rePasswd;
	}
	
	public void setRePasswd(String rePasswd) {
		this.rePasswd = rePasswd;
	}

	public String getUserimg() {
		return userimg;
	}

	public void setUserimg(String userimg) {
		this.userimg = userimg;
	}

	public Timestamp getAdddate() {
		return adddate;
	}

	public void setAdddate(Timestamp adddate) {
		this.adddate = adddate;
	}

	public String getWtmtype() {
		return wtmtype;
	}

	public void setWtmtype(String wtmtype) {
		this.wtmtype = wtmtype;
	}
    
    
}
