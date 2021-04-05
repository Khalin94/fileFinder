<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>

<%!// �Լ���


	//****** ���ϸ� ���� �ʿ�� ȣ�� �Լ� ******//
	private String make_filename(String _filename)
	{
		/*/////////////////////////////////////////////////////////////////////////////////
		���ϸ������ ���ε� �Ͻ� ���	�Ʒ��� ���� ������� ���� ���� �ֽø� �˴ϴ�.
		���� _filename �� ������ ���� ���Դϴ�.

		����) ���ϸ��� �и�������� �����ϰ� ���� ���
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
		���ϸ������ ���ε� �Ͻ� ���	�Ʒ��� ���� ������� ���� ���� �ֽø� �˴ϴ�.
		���� _filename �� ������ ���� ���Դϴ�.

		����) ���ϸ��� �и�������� �����ϰ� ���� ���
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

	//******  �ߺ� ���ϸ� �ѹ��� �Լ� ******//
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
            // ������ ���� �ϸ� ���ϸ� �ѹ��� (ex) test.txt ���� �ϸ� test(1).txt -> test(2).txt -> test(3).txt -> .....
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

	//****** ���ε� ������ �������� ������� ���� ******//
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
				// java 1.6 �̻󿡼� ����
				// tmp.setWritable(true, true);
			}
		}
	}

%>

<%// �����

	String _ROOT_DIR = "/mnt/nads/reqsubmit/pdf_temp"; // ������ġ(���� �ʿ�� �������ּ���)	// �׽�Ʈ ����
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

		// �ӽ� �������� ����
		File fp_tmp_folder = new File(tmp_folder);
		if(false == fp_tmp_folder.exists())
		{
			fp_tmp_folder.mkdir();
			// java 1.6 �̻󿡼� ����
			// fp_tmp_folder.setWritable(true, true);
		}
        //request �� ����
		Enumeration enum1 = request.getParameterNames();
		String reqName = "";
		String reqValue = "";
		
		while(enum1.hasMoreElements()) {
			reqName = (String)enum1.nextElement();
			reqValue = request.getParameter(reqName);
			System.out.println("kangthis logs reqName : " + reqName + "===== reqValue : " + reqValue);
		}

        // Multipart Request ��ü ����
        MultipartRequest multi = null;
        multi = new MultipartRequest(request, tmp_folder, maxSize, "EUC-KR", new DefaultFileRenamePolicy());
		Enumeration<String> Te = multi.getParameterNames();
		//Enumeration<String> Te = multi.getFileNames();
		while(Te.hasMoreElements()) {
			String param = Te.nextElement();
			System.out.println("kangthis logs =====================" );
			System.out.println(param);
		}

        // �������� �� �Ķ���� ����
        String action = multi.getParameter("_action");
	System.out.println("kangthis logs action : " +action);
        String file_name = null;
        String folder = null;
        String new_filename = null;
        String full_path = null;
        long file_size;


		// ������͸� �Ķ���� ����
		sub_dir = multi.getParameter("_SUB_DIR");
        	if( sub_dir != null ) {
			real_folder += File.separator;
            		real_folder += sub_dir;
		}
		real_folder += File.separator;


		//  ���� ���� ����
		File fp_dir = new File(real_folder);
		if(false == fp_dir.exists()) {
			fp_dir.mkdir();
			// java 1.6 �̻󿡼� ����
			// fp_dir.setWritable(true, true);
		}

System.out.println("-----------------------------CBC TEST_MESSAGE ---------------------");
		if (action != null && action.equals("getFileInfo")) {
System.out.println("action: " + action);
			// _folder �Ķ� �ޱ�
			folder = multi.getParameter("_folder");
			// _filename �Ķ� �ޱ�
			file_name = multi.getParameter("_filename");
			// _newname �Ķ� �ޱ�
			//new_filename = multi.getParameter("_newname");
			
			
			//hgyoo if(file_name.toLowerCase().indexOf("pdf.pdf") == -1){	
			System.out.println("hgyoo pdf.pdf ���� :"+file_name);
				new_filename = make_filename(file_name);		
				
			/* if(file_name.toLowerCase().indexOf(".pdf") == -1){				
				System.out.println("hgyoo pdf.pdf ���� :"+file_name);
				new_filename = make_filename(file_name);
			}else{
				System.out.println("hgyoo pdf.pdf ���� :"+file_name);
				new_filename = make_filename2(file_name);

			} */
			//new_filename = make_filename(file_name);
			file_size = 0;

System.out.println("folder: " + folder);
System.out.println("file_name: " + file_name);
System.out.println("new_filename: " + new_filename);

			// ���� ���ε� ó��
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

			if( new_filename != null )			// ���� �̾��
			{
                full_path = (real_folder+folder+new_filename);
				File fp_fullpath = new File(full_path);
				if( true == fp_fullpath.exists() )
				{
					file_size = fp_fullpath.length();
				}
			}
			else		// ���ο� ���� ���ε�
			{
                new_filename = make_filename(file_name);
				full_path = (real_folder + folder + file_name);
                // ���� ���ϸ� ���� Ȯ�� �� ���� ���ϸ��� �����ϸ� �� ���ϸ� ����
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
			file_name = multi.getParameter("_filename");  // �����̸�
			folder = multi.getParameter("_folder");  // ���ε��� ����
			file_size = Long.parseLong(multi.getParameter("_filesize")); // ���ε�� ���� ������
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

            //	���� ���� ���� Ȯ��
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
            //System.out.println("���� : " + file_name);
			//fp_tmp_folder.delete();
		}

		/* �ӽ� ���� ���� ����
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
