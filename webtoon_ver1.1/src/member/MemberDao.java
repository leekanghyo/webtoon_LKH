package member;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class MemberDao {

	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	private static MemberDao instance = new MemberDao();

	private MemberDao() {
		Context initContext;
		try {
			initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			DataSource ds = (DataSource) envContext.lookup("jdbc/OracleDB");
			conn = ds.getConnection();
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();

		}
	}

	public static MemberDao getInstance() {

		return instance;
	}

	public void closeSqlObject() {
		try {
			if (rs != null) {
				rs.close();
			}

			if (pstmt != null) {
				pstmt.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public int searchID(String userId) {
		int cnt = 0;
		String sql = "select id from wt_member where id=?";

		try {

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				cnt = 1;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
		return cnt;
	}

	// 회원 가입
	public int insertMember(MemberBean bean) {
		int cnt = -1;
		// 넘버,아이디,네임,패스워드,이미지경로,날짜,회원 타입
		String sql = "insert into wt_member values(wtm_seq.nextval,?,?,?,?,sysdate,?)";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, bean.getId());
			pstmt.setString(2, bean.getName());
			pstmt.setString(3, bean.getPasswd());
			pstmt.setString(4, bean.getUserimg());
			pstmt.setString(5, bean.getWtmtype());
			cnt = pstmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}

		return cnt;
	}

	public MemberBean memberInfo(String id, String passwd) {
		MemberBean bean = null;
		try {
			String sql = "select * from wt_member where id=? and passwd=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, passwd);

			rs = pstmt.executeQuery();

			// 정보가 있을 경우
			if (rs.next()) {
				bean = new MemberBean();
				bean = getMemberBean(rs);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
		return bean;
	}

	public String writerImg(String id) {
		String img = null;
		try {
			String sql = "select userimg from wt_member where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);

			rs = pstmt.executeQuery();

			// 정보가 있을 경우
			if (rs.next()) {
				img = rs.getString("userimg");
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
		return img;
	}

	public MemberBean getMemberBean(ResultSet rs) {
		MemberBean bean = new MemberBean();

		try {
			bean.setNum(rs.getInt("num"));
			bean.setId(rs.getString("id"));
			bean.setName(rs.getString("name"));
			bean.setPasswd(rs.getString("passwd"));
			bean.setUserimg(rs.getString("userimg"));
			bean.setAdddate(rs.getTimestamp("adddate"));
			bean.setWtmtype(rs.getString("wtmtype"));

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return bean;
	}

	public int updateMember(MemberBean bean) {

		int cnt = -1;

		String sql = "update wt_member set passwd=?, name =?, userimg=? where id=? and passwd=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, bean.getRePasswd());
			pstmt.setString(2, bean.getName());
			pstmt.setString(3, bean.getUserimg());
			pstmt.setString(4, bean.getId());
			pstmt.setString(5, bean.getPasswd());

			cnt = pstmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}

		return cnt;
	}

	public ArrayList<MemberBean> getAllMember() {
		ArrayList<MemberBean> list = new ArrayList<MemberBean>();

		try {
			String sql = "select * from wt_member where wtmtype <> 'admin' order by num asc";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				list.add(getMemberBean(rs));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}

		return list;
	}

	// DB 내 해당 유저의 모든 정보를 삭제
	public void deleteMember(String memId) {
		String sql;

		try {
			sql = "delete from wt_member where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, memId);
			int cnt;
			cnt = pstmt.executeUpdate();
			if (cnt > 0) {
				System.out.println(memId + "- wt_member DB 삭제 성공");
			}

			sql = "delete from wt_writer where writerid=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, memId);
			cnt = pstmt.executeUpdate();
			if (cnt > 0) {
				System.out.println(memId + "- wt_writer DB 삭제 성공");
			}

			sql = "delete from wt_list where writerid=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, memId);
			cnt = pstmt.executeUpdate();
			if (cnt > 0) {
				System.out.println(memId + "- wt_list DB 삭제 성공");
			}

			sql = "delete from wtc_like where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, memId);
			cnt = pstmt.executeUpdate();
			if (cnt > 0) {
				System.out.println(memId + "- wtc_like DB 삭제 성공");
			}
			sql = "delete from wt_library where id =?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, memId);
			cnt = pstmt.executeUpdate();
			if (cnt > 0) {
				System.out.println(memId + "- wt_library DB 삭제 성공");
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
	}

	// ---------------------------
	public void FileAllDelete(File file) {
		File[] files = file.listFiles();
		for (int i = 0; i < files.length; i++) {
			if (files[i].isFile()) {
				files[i].delete();
			}
			if (files[i].isDirectory()) {
				FileAllDelete(files[i]);
			}
			files[i].delete();
		}

		file.delete();

	}
	// 폴더 내 하위 데이터를 모두 지우는 메서드

	public ArrayList<Integer> getAllLibray(String id) {
		ArrayList<Integer> myLib = new ArrayList<Integer>();

		try {
			String sql = "select worknum from wt_library where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				myLib.add(rs.getInt("worknum"));
			}
		} catch (SQLException e) {

		} finally {
			closeSqlObject();
		}
		return myLib;
	}

	public int addLibrary(String memId, int workNum) {
		int cnt = -1;

		String sql = "insert into wt_library values(?,?)";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, memId);
			pstmt.setInt(2, workNum);
			cnt = pstmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}

		return cnt;
	}

	public int delLibrary(String memId, int workNum) {
		int cnt = -1;

		String sql = "delete from wt_library where id =? and workNum=?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, memId);
			pstmt.setInt(2, workNum);
			cnt = pstmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
		return cnt;
	}
}
