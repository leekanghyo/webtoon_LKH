package list;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class ListDao {

	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	private static ListDao instance = new ListDao();

	private ListDao() {
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

	public static ListDao getInstance() {

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

	// 폴더를 구분하기 위해 인서트 과정을 2번 거침
	// DB 작성후, seq로 발급되는 id를 반환. 이후 업로드 폴더 생성 후 이미지 정보 삽입, 일반 게시글일 경우 생략
	public String insertList(ListBean bean) {
		String num = null;
		String sql = "insert into "
				+ "wt_list(num,listtype, whatcontents, writerid, writerName, subject, content, reg_date, readcount, img, ref, re_step, re_level, temp, liked)"
				+ "values(wtlist_seq.nextval,?,?,?,?,?,?,sysdate,0,?,wtlist_seq.currval,?,?,'a',0)";
		// System.out.println("getInstance : " + "serch");
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, bean.getListType());
			pstmt.setString(2, bean.getWhatcontents());
			pstmt.setString(3, bean.getWriterId());
			pstmt.setString(4, bean.getWriterName());
			pstmt.setString(5, bean.getSubject());
			pstmt.setString(6, bean.getContent());
			pstmt.setString(7, bean.getImg());
			pstmt.setInt(8, 0);
			pstmt.setInt(9, 0);
			pstmt.executeUpdate();

			sql = "select num from wt_list where temp='a'";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				num = String.valueOf(rs.getInt("num"));
				sql = "update wt_list set temp=null where num=?";
				pstmt = conn.prepareStatement(sql);

				pstmt.setInt(1, rs.getInt("num"));
				pstmt.executeUpdate();

			}
			// 웹툰 댓글일 경우 댓글 정보를 수집한다.
			if (bean.getListType().equals("toon")) {
				String workName = bean.getWhatcontents().replaceAll("[0-9]", "");
				int episode = Integer.parseInt(bean.getWhatcontents().replaceAll("\\D", ""));
				sql = "update wt_contents set wtcreply = wtcreply + 1 where workname=? and episode=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, workName);
				pstmt.setInt(2, episode);
				pstmt.executeUpdate();
			}

		} catch (SQLException e) {

			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
		return num;
	}

	// 모든 공지사항 획득 (어드민 메인 및 공지사항 페이지에서 출력)
	public ArrayList<ListBean> getAllNotice() {
		ArrayList<ListBean> list = new ArrayList<ListBean>();
		String sql = "select * from wt_list where whatcontents is null";

		try {

			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				list.add(setListBean(rs));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
		return list;
	}

	// 공지 게시판 페이지에서 표시할 목록
	public ArrayList<ListBean> getAllNoticeFilter(String sortMode, int startRow, int endRow) {
		ArrayList<ListBean> list = new ArrayList<ListBean>();
		String sql;
		// System.out.println("getAllNoticeFilter : " + "serch");
		try {
			if (sortMode.equals("all")) {
				sql = "select num,listtype,whatcontents,img,writerid,writerName,subject,content,reg_date,readcount,ref,re_step,re_level,temp,liked "
						+ "from (select rownum as rank, num ,listtype,whatcontents,img,writerid,writerName,subject,content,reg_date,readcount,ref,re_step,re_level,temp,liked "
						+ "from(select num,listtype,whatcontents,img,writerid,writerName,subject,content,reg_date,readcount,ref,re_step,re_level,temp, liked "
						+ "from wt_list order by ref desc, re_level asc) where whatcontents is null) where rank between ? and ?";

				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, startRow);
				pstmt.setInt(2, endRow);
				rs = pstmt.executeQuery();

				while (rs.next()) {
					ListBean bean = setListBean(rs);
					list.add(bean);
				}

			} else {
				sql = "select num,listtype,whatcontents,img,writerid,writerName,subject,content,reg_date,readcount,ref,re_step,re_level,temp, liked "
						+ "from (select rownum as rank, num ,listtype,whatcontents,img,writerid,writerName,subject,content,reg_date,readcount,ref,re_step,re_level,temp,liked "
						+ "from(select num,listtype,whatcontents,img,writerid,writerName,subject,content,reg_date,readcount,ref,re_step,re_level,temp,liked "
						+ "from wt_list order by ref desc, re_level asc) where whatcontents is null and listtype=?) where rank between ? and ? ";

				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, sortMode);
				pstmt.setInt(2, startRow);
				pstmt.setInt(3, endRow);

				rs = pstmt.executeQuery();

				while (rs.next()) {
					ListBean bean = setListBean(rs);
					list.add(bean);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}

		return list;
	}

	// 개별 공지사항 획득
	public ListBean getNotice(int noticeNum) {
		ListBean bean = null;

		String sql = "select * from wt_list where num=?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, noticeNum);

			rs = pstmt.executeQuery();
			// System.out.println("noticeNum : " + noticeNum);
			if (rs.next()) {
				bean = setListBean(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
		return bean;
	}

	public ListBean setListBean(ResultSet rs) {
		ListBean bean = null;

		try {
			int num = rs.getInt("num");
			String listType = rs.getString("listtype");
			String whatcontents = rs.getString("whatcontents");
			String img = rs.getString("img");
			String writerId = rs.getString("writerid");
			String writerName = rs.getString("writerName");
			String subject = rs.getString("subject");
			String content = rs.getString("content");
			Timestamp reg_date = rs.getTimestamp("reg_date");
			int readcount = rs.getInt("readcount");
			int ref = rs.getInt("ref");
			int re_step = rs.getInt("re_step");
			int re_level = rs.getInt("re_level");
			int liked = rs.getInt("liked");

			bean = new ListBean(num, listType, whatcontents, img, writerId, writerName, subject, content, reg_date,
					readcount, ref, re_step, re_level, liked);
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return bean;
	}

	// 공지사항 삭제
	public int deleteList(int noticeNum) {
		int cnt = -1;

		String sql = "delete from wt_list where num=?";
		// System.out.println("noticeNum : " + noticeNum);
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, noticeNum);
			cnt = pstmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();

		} finally {
			closeSqlObject();
		}

		return cnt;
	}

	// 공지사항 업데이트
	public int updateNotice(ListBean bean) {
		int cnt = -1;

		String sql = "update wt_list set subject=?, content=?, img=? where num=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, bean.getSubject());
			pstmt.setString(2, bean.getContent());
			pstmt.setString(3, bean.getImg());
			pstmt.setInt(4, bean.getNum());
			cnt = pstmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}

		return cnt;
	}

	// 메인 화면에 출력할 공지사항 리스트
	public ArrayList<ListBean> getNoticesMain(int maxNoticeCount) {
		ArrayList<ListBean> list = new ArrayList<ListBean>();
		// System.out.println("getNoticesMain : " + "serch");
		try {// 최신 순으로 랭크를 매겨 1 ~ maxNoticeCount 만큼 출력한다.
			String sql = "select num,listtype,whatcontents,img,writerid,writerName,subject,content,reg_date,readcount,ref,re_step,re_level, liked "
					+ "from (select rownum as rank, num ,listtype,whatcontents,img,writerid,writerName,subject,content,reg_date,readcount,ref,re_step,re_level, liked "
					+ "from(select num,listtype,whatcontents,img,writerid,writerName,subject,content,reg_date,readcount,ref,re_step,re_level, liked "
					+ "from wt_list where whatcontents is null order by ref desc, re_level asc)) where rank between 1 and ?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, maxNoticeCount);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				ListBean bean = setListBean(rs);
				list.add(bean);
			}

		} catch (SQLException e) {
			e.printStackTrace();

		} finally {
			closeSqlObject();
		}

		return list;
	}

	public int getNoticeListCount(String sortMode) {
		int rowCount = 0;

		try {
			String sql;

			if (sortMode.equals("all")) {
				sql = "select count(*) as count from wt_list where whatcontents is null";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();

				if (rs.next()) {
					rowCount = rs.getInt("count");
				}

			} else {
				/* System.out.println("sortMode" + sortMode); */
				sql = "select count(*) as count from wt_list where listtype=? and whatcontents is null";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, sortMode);
				rs = pstmt.executeQuery();

				if (rs.next()) {
					rowCount = rs.getInt("count");
				}

			}
		} catch (SQLException e) {
			e.printStackTrace();

		} finally {
			closeSqlObject();
		}

		return rowCount;
	}

	// 게시판리스트 추가
	public int insertBoardList(String boardName) {
		int cnt = -1;
		try {
			String sql = "insert into wt_board_list values(wt_board_list_seq.nextval,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, boardName);
			cnt = pstmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
		return cnt;
	}

	// 게시판 리스트 획득
	public ArrayList<BoardCategoryBean> getBoardList() {
		ArrayList<BoardCategoryBean> list = new ArrayList<BoardCategoryBean>();

		String sql = "select * from wt_board_list";

		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				BoardCategoryBean bean = new BoardCategoryBean();
				bean.setNum(rs.getInt("num"));
				bean.setBoardName(rs.getString("boardname"));
				list.add(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
		return list;
	}

	// 각 게시판 글들 갯수 획득
	public int getBoardCount(String sortMode, String boardName) {
		int rowCount = 0;
		try {

			String sql;

			if (sortMode.equals("all")) {
				sql = "select count(*) as count from wt_list where whatcontents =?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, boardName);

				rs = pstmt.executeQuery();
				if (rs.next()) {
					rowCount = rs.getInt("count");
				}
			} else { // 내가 쓴글
				sql = "select count(*) as count from wt_list where whatcontents =? and writerid =?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, boardName);
				pstmt.setString(2, sortMode);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					rowCount = rs.getInt("count");
				}

			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}

		return rowCount;
	}

	public ArrayList<ListBean> getAllBoardContentFilter(String sortMode, String boardName, int startRow, int endRow) {
		ArrayList<ListBean> list = new ArrayList<ListBean>();

		try {
			String sql;

			if (!sortMode.equals("all")) {
				sql = "select num,listtype,whatcontents,img,writerid,writerName,subject,content,reg_date,readcount,ref,re_step,re_level,temp, liked "
						+ "from (select rownum as rank, num ,listtype,whatcontents,img,writerid,writerName,subject,content,reg_date,readcount,ref,re_step,re_level,temp,liked "
						+ "from(select num,listtype,whatcontents,img,writerid,writerName,subject,content,reg_date,readcount,ref,re_step,re_level,temp,liked "
						+ "from wt_list order by ref desc, re_level asc)) where rank between ? and ? and whatcontents=? and writerid=?";

				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, startRow);
				pstmt.setInt(2, endRow);
				pstmt.setString(3, boardName);
				pstmt.setString(4, sortMode);
				rs = pstmt.executeQuery();

				while (rs.next()) {
					list.add(setListBean(rs));
				}
			} else {
				sql = "select num,listtype,whatcontents,img,writerid,writerName,subject,content,reg_date,readcount,ref,re_step,re_level,temp, liked "
						+ "from (select rownum as rank, num ,listtype,whatcontents,img,writerid,writerName,subject,content,reg_date,readcount,ref,re_step,re_level,temp,liked "
						+ "from(select num,listtype,whatcontents,img,writerid,writerName,subject,content,reg_date,readcount,ref,re_step,re_level,temp,liked "
						+ "from wt_list order by ref desc, re_level asc)) where rank between ? and ? and whatcontents=?";

				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, startRow);
				pstmt.setInt(2, endRow);
				pstmt.setString(3, boardName);
				rs = pstmt.executeQuery();

				while (rs.next()) {
					list.add(setListBean(rs));
				}
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}

		return list;
	}

	// 각 게시판의 특정 게시글을 불러옴 (getNotice와 메서드 통합 예정)
	public ListBean getBoardContent(int contentNum) {
		ListBean bean = new ListBean();
		try {
			String sql = "select * from wt_list where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, contentNum);

			rs = pstmt.executeQuery();
			// System.out.println("noticeNum : " + noticeNum);
			if (rs.next()) {
				bean = setListBean(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}

		return bean;
	}

	// 각 웹툰 화별 댓글 호출
	public ArrayList<ListBean> getReply(String workName, int episode) {
		ArrayList<ListBean> list = new ArrayList<ListBean>();

		String whatcontents = workName + episode;
		String sql = "select * from wt_list where listtype ='toon' and whatcontents=? order by num desc";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, whatcontents);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				ListBean lbean = setListBean(rs);
				list.add(lbean);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}

		return list;
	}

	public int likeCheck(String memid, String workName, String episode) {
		int count = 0;
		String whatcontents = workName + episode;
		String sql = "select count(*) as count from wtc_like where id=? and whatcontents =?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, memid);
			pstmt.setString(2, whatcontents);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				count = rs.getInt("count");
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}

		return count;

	}

	public void likeAdd(String memid, String workName, String episode) {

		String whatcontents = workName + episode;
		String sql = "insert into wtc_like values(?,?)";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, memid);
			pstmt.setString(2, whatcontents);
			int cnt = pstmt.executeUpdate();

			if (cnt > 0) {
				sql = "update wt_writer set liked = liked + 1 where workname=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, workName);
				pstmt.executeUpdate();
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
	}

	public int deleteReply(int num, String workName, int episode) {
		int cnt = -1;

		String sql = "delete from wt_list where num =?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);

			cnt = pstmt.executeUpdate();

			sql = "update wt_contents set wtcreply = wtcreply - 1 where workname=? and episode=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, workName);
			pstmt.setInt(2, episode);
			pstmt.executeUpdate();

		} catch (SQLException e) {

			e.printStackTrace();
		} finally {
			closeSqlObject();
		}

		return cnt;
	}

	public void boardDB_delete(String boardCategoryName, int boardCategoryNum) {
		String sql;

		try {
			sql = "delete from wt_list where whatcontents=?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, boardCategoryName);

			int cnt;

			cnt = pstmt.executeUpdate();

			if (cnt > 0) {
				System.out.println("wt_list 데이터 삭제 완료");
			} else {
				System.out.println("wt_list 데이터 삭제 실패");
				return;
			}

			sql = "delete from wt_board_list where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, boardCategoryNum);

			cnt = pstmt.executeUpdate();

			if (cnt > 0) {
				System.out.println("wt_board_list 데이터 삭제 완료");
			} else {
				System.out.println("wt_board_list 데이터 삭제 실패");
				return;
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

	// 멤버 탈퇴를 위해 멤버가 작성한 게시글 번호를 호출하는 메서드
	public HashMap<String, Integer> getBoardNum(String memId) {

		HashMap<String, Integer> boardData = new HashMap<String, Integer>();

		try {
			String sql = "select num, whatcontents from wt_list where writerid =?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, memId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				boardData.put(rs.getString("whatcontents"), rs.getInt("num"));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}

		return boardData;
	}

	public void readCounting(int Num) {
		String sql = "update wt_list set readcount = readcount+1 where num=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, Num);
			pstmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}

	}
}
