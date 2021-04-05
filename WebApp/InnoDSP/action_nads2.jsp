<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="nads.lib.reqsubmit.util.FileUtil"%>
<%!// �Լ���


	//****** ���ϸ� ���� �ʿ�� ȣ�� �Լ� ******//
	private String make_filename(String _filename,String new_filename)
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
		_filename = new_filename+ext;
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
    int maxSize = 1024*1024*1024;
	int BUFFER_SIZE = 51200;

    try
	{
		real_folder = save_folder;
		tmp_folder = real_folder+tmp_folder+File.separator;

		// �ӽ� �������� ����
		File fp_tmp_folder = new File(tmp_folder);
		if(false == fp_tmp_folder.exists())
		{
			fp_tmp_folder.mkdir();
		}

        MultipartRequest multi = null;
        multi = new MultipartRequest(request, tmp_folder, maxSize, "EUC-KR", new DefaultFileRenamePolicy());


        // �������� �� �Ķ���� ����
        String action = multi.getParameter("_action");
		String filename[] = multi.getParameterValues("filename");
		String newfilename[] = multi.getParameterValues("newfilename");

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
		}
		
		System.out.println("-----------------------------CBC TEST_MESSAGE ---------------------:"+filename.length);
		for(int j=0; j<filename.length; j++){
			file_name = filename[j];
			new_filename = make_filename(file_name,newfilename[j]);

			FileUtil.copyFile(tmp_folder+file_name, real_folder+new_filename);
			if( true == fp_tmp_folder.exists() )
			{
		        File fp_tmp = new File(tmp_folder + file_name);
	            fp_tmp.delete();
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
