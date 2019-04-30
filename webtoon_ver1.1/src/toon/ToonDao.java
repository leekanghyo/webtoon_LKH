package toon;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sound.midi.Synthesizer;
import javax.sql.DataSource;

public class ToonDao {
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	private static ToonDao instance = new ToonDao();

	private ToonDao() {
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

	public static ToonDao getInstance() {
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

	// 첫 작품 등록, 작가 테이블 /컨텐츠 테이블
	public int addWork(ContentBean cbean, WriterBean wbean) {
		int cnt = -1;
		try {

			// 작가 테이블 인서트
			String writer_sql = "insert into wt_writer values(wtw_seq.nextval,?,?,?,?,?,?,sysdate,?,0,0,0)";

			pstmt = conn.prepareStatement(writer_sql);
			pstmt.setString(1, wbean.getWriterId());
			pstmt.setString(2, wbean.getWriterName());
			pstmt.setString(3, wbean.getWorkName());
			pstmt.setString(4, wbean.getTitleImage());
			pstmt.setString(5, wbean.getSynop());
			pstmt.setString(6, wbean.getGenre());
			pstmt.setInt(7, wbean.getWriteWeek());
			cnt += pstmt.executeUpdate();

			// 작가 테이블 인서트
			writer_sql = "select last_number from user_sequences where sequence_name= upper('wtw_seq')";
			pstmt = conn.prepareStatement(writer_sql);
			rs = pstmt.executeQuery();

			int workNum = 0;
			if (rs.next()) {
				workNum = rs.getInt("last_number") - 1;
				System.out.println(workNum);
			}

			// ---------------------------------------------------------------------------------
			// 컨텐츠 테이블
			String content_sql = "insert into wt_contents values(wtc_seq.nextval,?,?,?,?,?,?,?,?,?,sysdate,0,0)";

			pstmt = conn.prepareStatement(content_sql);

			pstmt.setInt(1, workNum);
			pstmt.setString(2, cbean.getWriterId());
			pstmt.setString(3, cbean.getWriterName());
			pstmt.setString(4, cbean.getWorkName());
			pstmt.setInt(5, cbean.getEpisode());
			pstmt.setString(6, cbean.getSubtitle());
			pstmt.setString(7, cbean.getDescript());
			pstmt.setString(8, cbean.getWriterComment());
			pstmt.setString(9, cbean.getUpload_img());

			cnt += pstmt.executeUpdate();
			// 컨텐츠 테이블

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
		return cnt;
	}

	public ArrayList<WriterBean> getWorkList(String memid) {
		ArrayList<WriterBean> wList = new ArrayList<WriterBean>();

		String sql = "select * from wt_writer where writerid = ? order by num desc";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, memid);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				wList.add(getWriteBean(rs));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}

		return wList;
	}

	public WriterBean getWriteBean(ResultSet rs) {
		WriterBean wbean = new WriterBean();

		try {
			wbean.setNum(rs.getInt("num"));
			wbean.setWriterId(rs.getString("writerid"));
			wbean.setWriterName(rs.getString("writername"));
			wbean.setWorkName(rs.getString("workname"));
			wbean.setTitleImage(rs.getString("titleimage"));
			wbean.setSynop(rs.getString("synop"));
			wbean.setGenre(rs.getString("genre"));
			wbean.setWriteStart(rs.getTimestamp("writestart"));
			wbean.setWriteWeek(rs.getInt("writeweek"));
			wbean.setWriteEnd(rs.getInt("writeend"));
			wbean.setViewMode(rs.getInt("viewmode"));
			wbean.setLiked(rs.getInt("liked"));
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return wbean;
	}

	// 각각 웹툰 회수 정보 등 호출
	public ArrayList<ContentBean> getContentList(int workNum) {
		ArrayList<ContentBean> clist = new ArrayList<ContentBean>();
		// wt_writer에서 해당 번호에 해당하는 작품 명을 먼저 가져옴
		try {
			// ----------
			String wt_contents_sql = "select * from wt_contents where worknum=? order by num desc";
			// ----------
			pstmt = conn.prepareStatement(wt_contents_sql);
			pstmt.setInt(1, workNum);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				ContentBean cbean = getContentBean(rs);
				clist.add(cbean);
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
		return clist;
	}

	public ContentBean getContent(int workNum, int episode) {
		ContentBean cbean = new ContentBean();
		// wt_writer에서 해당 번호에 해당하는 작품 명을 먼저 가져옴
		try {
			// ----------
			String wt_contents_sql = "select * from wt_contents where worknum=? and episode=?";
			// ----------
			pstmt = conn.prepareStatement(wt_contents_sql);
			pstmt.setInt(1, workNum);
			pstmt.setInt(2, episode);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				cbean = getContentBean(rs);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
		return cbean;
	}

	public ContentBean getContentBean(ResultSet rs) {
		ContentBean cbean = new ContentBean();

		try {
			cbean.setNum(rs.getInt("num"));
			cbean.setWriterId(rs.getString("writerid"));
			cbean.setWorkNum(rs.getInt("worknum"));
			cbean.setWriterId(rs.getString("writerid"));
			cbean.setWriterName(rs.getString("writername"));
			cbean.setWorkName(rs.getString("workname"));
			cbean.setEpisode(rs.getInt("episode"));
			cbean.setSubtitle(rs.getString("subtitle"));
			cbean.setDescript(rs.getString("descript"));
			cbean.setWriterComment(rs.getString("writercomment"));
			cbean.setUpload_img(rs.getString("upload_img"));
			cbean.setUpload_date(rs.getTimestamp("upload_date"));
			cbean.setWtcReadCount(rs.getInt("wtcreadcount"));
			cbean.setWtcReply(rs.getInt("wtcreply"));
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return cbean;
	}

	public WriterBean getWriter(int workNum) {
		WriterBean wbean = new WriterBean();
		String sql = "select * from wt_writer where num=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, workNum);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				wbean = getWriteBean(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
		return wbean;
	}

	public ArrayList<WriterBean> getWeeklyToon(int weekNum) {
		ArrayList<WriterBean> wlist = new ArrayList<WriterBean>();

		String sql = "select * from wt_writer where writeweek=? and viewmode = 0 and writeend=0 order by liked desc ";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, weekNum);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				WriterBean wbean = new WriterBean();
				wbean = getWriteBean(rs);
				wlist.add(wbean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
		return wlist;
	}

	// 완결본 취득
	public ArrayList<WriterBean> getCompleteToon() {
		ArrayList<WriterBean> wlist = new ArrayList<WriterBean>();

		String sql = "select * from wt_writer where writeend=1 and viewmode = 0 order by liked desc ";
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				WriterBean wbean = new WriterBean();
				wbean = getWriteBean(rs);
				wlist.add(wbean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}

		return wlist;
	}

	public int getNextEpisode(int workNum) {
		int nextNum = 0;
		String sql = "select max(episode) as max from wt_contents where workNum=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, workNum);
			rs = pstmt.executeQuery();
			if (rs.next()) {

				int max = rs.getInt("max");

				if (max <= 0) {
					System.out.println("getNextEpisode : DB 등록 정보 없음");
				} else {
					nextNum += max + 1;
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}

		return nextNum;
	}

	public int addContents(ContentBean cbean, int workNum) {
		int cnt = -1;
		String content_sql = "insert into wt_contents values(wtc_seq.nextval,?,?,?,?,?,?,?,?,?,sysdate,0,0)";

		try {
			pstmt = conn.prepareStatement(content_sql);

			pstmt.setInt(1, workNum);
			pstmt.setString(2, cbean.getWriterId());
			pstmt.setString(3, cbean.getWriterName());
			pstmt.setString(4, cbean.getWorkName());
			pstmt.setInt(5, cbean.getEpisode());
			pstmt.setString(6, cbean.getSubtitle());
			pstmt.setString(7, cbean.getDescript());
			pstmt.setString(8, cbean.getWriterComment());
			pstmt.setString(9, cbean.getUpload_img());

			cnt = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}

		return cnt;
	}

	public int getContentsMaxCount(int workNum) {
		int maxNum = 0;
		String sql = "select max(episode) as maxepisode from wt_contents where worknum=?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, workNum);

			rs = pstmt.executeQuery();
			if (rs.next()) {
				maxNum = rs.getInt("maxepisode");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
		return maxNum;
	}

	public ArrayList<WriterBean> getContentListByRank() {
		ArrayList<WriterBean> wlist = new ArrayList<WriterBean>();
		// 1위에서부터 10위 까지 카운트
		String sql = "select num, writerid, writername, workname, titleimage, synop, genre, writestart, writeweek, writeend,viewmode,liked "
				+ "from (select liked as rank, num, writerid, writername, workname, titleimage, synop, genre, writestart, writeweek, writeend,viewmode,liked "
				+ "from (select num, writerid, writername, workname, titleimage, synop, genre, writestart, writeweek, writeend,viewmode,liked "
				+ "from wt_writer order by liked desc)) where num between 1 and 10 and viewmode=0";

		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				wlist.add(getWriteBean(rs));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
		return wlist;
	}

	public int changeViewMode(int workNum, int viewMode) {
		int cnt = -1;
		System.out.println("workNum" + workNum);
		System.out.println("viewMode" + viewMode);
		try {
			String sql = "update wt_writer set viewmode =? where num =?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, viewMode);
			pstmt.setInt(2, workNum);
			cnt = pstmt.executeUpdate();

		} catch (SQLException e) {

			e.printStackTrace();
		} finally {
			closeSqlObject();
		}

		return cnt;
	}

	public int updateContent(ContentBean cbean) {
		int cnt = -1;

		try {
			System.out.println("Asd");
			String sql = "update wt_contents set subtitle =?, descript =?, writercomment=?, upload_img=? where workname=? and episode=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, cbean.getSubtitle());
			pstmt.setString(2, cbean.getDescript());
			pstmt.setString(3, cbean.getWriterComment());
			pstmt.setString(4, cbean.getUpload_img());

			pstmt.setString(5, cbean.getWorkName());
			pstmt.setInt(6, cbean.getEpisode());

			cnt = pstmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
		return cnt;
	}

	public int deletToon(String workName, int episode) {
		int cnt = -1;
		String sql;

		try {

			sql = "delete from wtc_like where whatcontents=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, workName + episode);
			cnt = pstmt.executeUpdate();

			if (cnt < 0) {
				System.out.println("wtc_like 데이터 제거 실패");
				return cnt;
			}

			sql = "delete from wt_list where whatcontents=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, workName + episode);
			cnt = pstmt.executeUpdate();

			if (cnt < 0) {
				System.out.println("wt_list 데이터 제거 실패");
				return cnt;
			}

			sql = "delete from wt_contents where workname=? and episode=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, workName);
			pstmt.setInt(2, episode);
			cnt = pstmt.executeUpdate();

			if (cnt < 0) {
				System.out.println("wt_contents 데이터 제거 실패");
				return cnt;
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
		return cnt;
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

	public int setWriteEnd(int workNum, int writeEnd) {
		int cnt = -1;
		String sql = "update wt_writer set writeend =? where num =?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, writeEnd);
			pstmt.setInt(2, workNum);

			cnt = pstmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();

		} finally {
			closeSqlObject();
		}

		return cnt;
	}

	public ArrayList<WriterBean> getMyLibrary(ArrayList<Integer> myLib) {
		ArrayList<WriterBean> wlist = new ArrayList<WriterBean>();

		String sql = "select * from wt_writer where num=?";

		try {
			for (int worknum : myLib) {
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, worknum);
				rs = pstmt.executeQuery();

				if (rs.next()) {
					wlist.add(getWriteBean(rs));
				}
				rs.close();
				pstmt.close();
			}

		} catch (SQLException e) {
			e.printStackTrace();

		} finally {
			closeSqlObject();
		}
		return wlist;
	}

	public boolean isMyLibrary(String memid, int workNum) {
		boolean answer = false;
		String sql = "select count(*) as cnt from wt_library where id =? and worknum =?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, memid);
			pstmt.setInt(2, workNum);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				int cnt = rs.getInt("cnt");
				System.out.println("cnt" + cnt);
				if (cnt > 0) {
					System.out.println("cnt" + cnt);
					answer = true;
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}
		return answer;
	}

	// 열람시 조회수 증가
	public void readCounting(int workNum, int episode) {
		String sql = "update wt_contents set wtcreadcount = wtcreadcount+1 where worknum=? and episode =?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, workNum);
			pstmt.setInt(2, episode);
			pstmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeSqlObject();
		}

	}

}
