<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>

<%!// 함수부


	//****** 파일명 변경 필요시 호출 함수 ******//
	private String make_filename(String _filename)
	{
		/*/////////////////////////////////////////////////////////////////////////////////
		파일명변경시켜 업로드 하실 경우	아래와 같은 방식으로 변경 시켜 주시면 됩니다.
		인자 _filename 은 변경전 파일 명입니다.

		예제) 파일명을 밀리세컨드로 변경하고 싶을 경우
		int ext_pos = _filename.lastIndexOf(".");
        String ext = _filename.substring(ext_pos);
		Date time = new Date();
		_filename = time.getTime()+ext;
		*/////////////////////////////////////////////////////////////////////////////////
		int ext_pos = _filename.lastIndexOf(".");
        String ext = _filename.substring(ext_pos);
		Date time = new Date();
		_filename = time.getTime()+ext;
		return _filename;
	}

	private String make_filename2(String _filename)
	{
		/*/////////////////////////////////////////////////////////////////////////////////
		파일명변경시켜 업로드 하실 경우	아래와 같은 방식으로 변경 시켜 주시면 됩니다.
		인자 _filename 은 변경전 파일 명입니다.

		예제) 파일명을 밀리세컨드로 변경하고 싶을 경우
		int ext_pos = _filename.lastIndexOf(".");
        String ext = _filename.substring(ext_pos);
		Date time = new Date();
		_filename = time.getTime()+ext;
		*/////////////////////////////////////////////////////////////////////////////////
		int ext_pos = _filename.lastIndexOf(".");
        String ext = _filename.substring(ext_pos);
		Date time = new Date();
		_filename = "ori_"+time.getTime()+ext;
		return _filename;
	}

	//******  중복 파일명 넘버링 함수 ******//
    private String file_rename(String _folder_path, String _filename)
    {
        String new_name;
        String full_path;
        int ext_pos = _filename.lastIndexOf(".");

        String name = _filename.substring(0, ext_pos);
        String ext = _filename.substring(ext_pos);

        int i=1;
        while(true)
        {
            // 파일이 존재 하면 파일명에 넘버링 (ex) test.txt 존재 하면 test(1).txt -> test(2).txt -> test(3).txt -> .....
            new_name = (name+"("+i+")"+ext);
            full_path = (_folder_path + new_name);

            if(false == (new File(full_path).exists()))
            {
                break;
            }
            i++;
        }
		return new_name;
    }

	//****** 업로드 폴더가 존재하지 않을경우 생성 ******//
	private void create_folder(String _real_folder, String _folder)
	{
		String folder_name = _real_folder;
		String[] _folder_arr = _folder.split(File.separator+File.separator);
		for(int i=0; i<_folder_arr.length; i++)
		{
			folder_name += (_folder_arr[i]+File.separator);
			File tmp = new File(folder_name);
			if( false == tmp.exists() )
			{
				tmp.mkdir();
				// java 1.6 이상에서 지원
				// tmp.setWritable(true, true);
			}
		}
	}

%>

<%// 실행부

	String _ROOT_DIR = "/mnt/nads/reqsubmit/pdf_temp"; // 저장위치(변경 필요시 수정해주세요)	// 테스트 서버
	String save_folder = _ROOT_DIR;
	String real_folder = "";
	String tmp_folder = File.separator+ "tmp";
	String sub_dir;
    int maxSize = 3*1024*1024;
	int BUFFER_SIZE = 51200;

    try
	{
                System.out.println("kangthis logs tmp_foler 111 => " + tmp_folder);
		real_folder = save_folder;
		tmp_folder = real_folder+tmp_folder+File.separator;
                System.out.println("kangthis logs tmp_foler 222 => " + tmp_folder);

		// 임시 저장폴더 생성
		File fp_tmp_folder = new File(tmp_folder);
		if(false == fp_tmp_folder.exists())
		{
			fp_tmp_folder.mkdir();
			// java 1.6 이상에서 지원
			// fp_tmp_folder.setWritable(true, true);
		}
        //request 값 찍어보기
		Enumeration enum1 = request.getParameterNames();
		String reqName = "";
		String reqValue = "";
		
		while(enum1.hasMoreElements()) {
			reqName = (String)enum1.nextElement();
			reqValue = request.getParameter(reqName);
			System.out.println("kangthis logs reqName : " + reqName + "===== reqValue : " + reqValue);
		}

        // Multipart Request 객체 생성
        MultipartRequest multi = null;
        multi = new MultipartRequest(request, tmp_folder, maxSize, "EUC-KR", new DefaultFileRenamePolicy());
		Enumeration<String> Te = multi.getParameterNames();
		//Enumeration<String> Te = multi.getFileNames();
		while(Te.hasMoreElements()) {
			String param = Te.nextElement();
			System.out.println("kangthis logs =====================" );
			System.out.println(param);
		}

        // 변수선언 및 파라미터 저장
        String action = multi.getParameter("_action");
	System.out.println("kangthis logs action : " +action);
        String file_name = null;
        String folder = null;
        String new_filename = null;
        String full_path = null;
        long file_size;


		// 서브디렉터리 파라미터 저장
		sub_dir = multi.getParameter("_SUB_DIR");
        	if( sub_dir != null ) {
			real_folder += File.separator;
            		real_folder += sub_dir;
		}
		real_folder += File.separator;


		//  저장 폴더 생성
		File fp_dir = new File(real_folder);
		if(false == fp_dir.exists()) {
			fp_dir.mkdir();
			// java 1.6 이상에서 지원
			// fp_dir.setWritable(true, true);
		}

System.out.println("-----------------------------CBC TEST_MESSAGE ---------------------");
		if (action != null && action.equals("getFileInfo")) {
System.out.println("action: " + action);
			// _folder 파람 받기
			folder = multi.getParameter("_folder");
			// _filename 파람 받기
			file_name = multi.getParameter("_filename");
			// _newname 파람 받기
			//new_filename = multi.getParameter("_newname");
			
			
			//hgyoo if(file_name.toLowerCase().indexOf("pdf.pdf") == -1){	
			System.out.println("hgyoo pdf.pdf 없음 :"+file_name);
				new_filename = make_filename(file_name);		
				
			/* if(file_name.toLowerCase().indexOf(".pdf") == -1){				
				System.out.println("hgyoo pdf.pdf 없음 :"+file_name);
				new_filename = make_filename(file_name);
			}else{
				System.out.println("hgyoo pdf.pdf 있음 :"+file_name);
				new_filename = make_filename2(file_name);

			} */
			//new_filename = make_filename(file_name);
			file_size = 0;

System.out.println("folder: " + folder);
System.out.println("file_name: " + file_name);
System.out.println("new_filename: " + new_filename);

			// 폴더 업로드 처리
			if( folder != null )
			{
				folder = folder.replaceAll("[\\\\]+", File.separator + File.separator);
				create_folder(real_folder, folder);
				folder += File.separator;
			}
			else
			{
				folder = "";
			}
System.out.println("folder2: " + folder);

			if( new_filename != null )			// 파일 이어쓰기
			{
                full_path = (real_folder+folder+new_filename);
				File fp_fullpath = new File(full_path);
				if( true == fp_fullpath.exists() )
				{
					file_size = fp_fullpath.length();
				}
			}
			else		// 새로운 파일 업로드
			{
                new_filename = make_filename(file_name);
				full_path = (real_folder + folder + file_name);
                // 동일 파일명 존재 확인 후 동일 파일명이 존재하면 새 파일명 생성
				File fp_fullpath = new File(full_path);
                if( true == fp_fullpath.exists() )
                {
                    new_filename = file_rename(real_folder+folder, file_name);
                    full_path = (real_folder + folder + new_filename);
                }

			}

			out.println("<file_offset>" + file_size + "</file_offset>");
			out.println("<file_name>" + new_filename + "</file_name>");
			out.println("<file_path>" + full_path + "</file_path>");
			
			System.out.println("file_size: " + file_size);
			System.out.println("new_filename: " + new_filename);
			System.out.println("full_path: " + full_path);
		}
		else if(action != null && action.equals("attachFile"))
		{
System.out.println("action: " + action);
			file_name = multi.getParameter("_filename");  // 파일이름
			folder = multi.getParameter("_folder");  // 업로드한 폴더
			file_size = Long.parseLong(multi.getParameter("_filesize")); // 업로드된 파일 사이즈
System.out.println("file_name: " + file_name);
System.out.println("folder: " + folder);
System.out.println("file_size: " + file_size);

			long current_size = 0;
			long exists_size = 0;
			long saved_size = 0;
			boolean append_flag = false;

			if(folder != null)
			{
				folder = folder.replaceAll("[\\\\]+", File.separator + File.separator);
				folder += File.separator;
			}
			else
			{
				folder = "";
			}



			File open_fp = multi.getFile("_file");
			current_size = open_fp.length();
			full_path = (real_folder + folder + file_name);


System.out.println("file_name: " + file_name);
System.out.println("full_path: " + full_path);

            //	기존 파일 존재 확인
            File save_fp = new File(full_path);
            if( true == save_fp.exists() )
            {
                append_flag = true;
                exists_size = save_fp.length();
            }

			saved_size = current_size + exists_size;

			FileOutputStream out_stream = null;
			FileInputStream in_stream =  null;
			try
			{
				out_stream = new FileOutputStream(save_fp, append_flag);
				in_stream = new FileInputStream(open_fp);
				byte buffer[] = new byte[BUFFER_SIZE];
				int bytes_read;

				while( true )
				{
					bytes_read = in_stream.read(buffer);

					if( bytes_read == -1 )
					{
						break;
					}
					out_stream.write(buffer, 0, bytes_read);
				}

				open_fp.delete();
			}
			catch (IOException e)
			{
				//
				out.println("<code>0001</code>");
				out.println("<file_offset>"+exists_size+"</file_offset>");

			}
			finally
			{
				if(in_stream != null)
				{
					try
					{
						in_stream.close();
					}catch(IOException e){};
				}
				if(out_stream != null)
				{
					try
					{
						out_stream.close();
					}catch(IOException e){};
				}

				out.println("<code>0000</code>");
			}
		}

		if( true == fp_tmp_folder.exists() )
		{
            //File fp_tmp = new File(tmp_folder + file_name);
            //fp_tmp.delete();
            //System.out.println("삭제 : " + file_name);
			//fp_tmp_folder.delete();
		}

		/* 임시 저장 폴더 삭제
		if( true == fp_tmp_folder.exists() )
		{
			String[] tmp_dir_files = fp_tmp_folder.list();

			for(int i=0; i<tmp_dir_files.length; i++)
			{
				File fp_tmp = new File(tmp_folder + tmp_dir_files[i]);
				fp_tmp.delete();
			}
			//fp_tmp_folder.delete();
		}*/



    }
    catch(Exception e)
    {
		//
    }


%>
