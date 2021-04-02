package org.bsta;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Hello world!
 *
 */
public class App 
{
    static int count = 0;
    static List<String> realFileList = new ArrayList<>();
    static List<String> pathInFileList = new ArrayList<>();
    static String regExp = "[a-zA-Z0-9_]*\\.jsp";
    public static void main( String[] args ) {
        
        //showFilesInDir(File.separator+"workspace"+File.separator+"fileFinder");

        // RealShowFilesInDir("C:"+File.separator+"Users"+File.separator+"LG"+File.separator+"Documents"+File.separator+"workspace-spring-tool-suite-4-4.8.0.RELEASE"+File.separator+"DSDM-Web"+File.separator+"WebApp"+File.separator+"sitemap");
        // System.out.println("count : " + count);
        // for(String fileName : realFileList){
        //     System.out.println("fileName : " + fileName);
        // }


        //showPathInFile("C:"+File.separator+"Users"+File.separator+"LG"+File.separator+"Documents"+File.separator+"workspace-spring-tool-suite-4-4.8.0.RELEASE"+File.separator+"DSDM-Web"+File.separator+"WebApp"+File.separator+"sitemap"+File.separator+"SiteMap.jsp");
        File file = new File("C:"+File.separator+"Users"+File.separator+"LG"+File.separator+"Documents"+File.separator+"workspace-spring-tool-suite-4-4.8.0.RELEASE"+File.separator+"DSDM-Web"+File.separator+"WebApp"+File.separator+"sitemap"+File.separator+"SiteMap.jsp");
        // String str = "<%@ include file=\"/reqsubmit/common/RUserCodeInfoInc.jsp\" %>";
        // System.out.println("str : " + str);
        // //String regExp = "/[a-zA-Z0-9_]*\\.jsp/s";
        // String regExp = "/[a-zA-Z0-9_]*\\.jsp";
        // Pattern pattern = Pattern.compile(regExp);
        // Matcher matcher = pattern.matcher(str);
        // System.out.println("matcher.find() : " + matcher.find());
        // while(matcher.find()){
        //     System.out.println(matcher.group(1));
        //     if(matcher.group(1) == null){
        //         break;
        //     }
        // }
        
        // if(file.getName().endsWith(".jsp")){
        //     BufferedReader inFile =null;
        //     try{
        //         inFile = new BufferedReader(new FileReader(file));
        //         String sLine = null;
        //         while((sLine = inFile.readLine()) != null){
        //             String jspFile = "";
        //             //System.out.println(sLine);
        //             Pattern pattern = Pattern.compile(regExp);
        //             Matcher matcher = pattern.matcher(sLine);
        //             // System.out.println("matcher.find()" + matcher.find());
        //             while(matcher.find() != false){
        //                 // if(matcher.group(1) == null){
        //                 //     break;
        //                 // }
        //                 System.out.println(matcher.group(0));
        //             }
                    
        //         }
        //     }catch(IOException e){
        //         e.printStackTrace();
        //     }

        //     if(inFile != null){

        //         try {
        //             inFile.close();
        //         } catch (IOException e) {
        //             e.printStackTrace();
        //         }
        //     }

        // }
        showPathInFile("C:"+File.separator+"Users"+File.separator+"LG"+File.separator+"Documents"+File.separator+"workspace-spring-tool-suite-4-4.8.0.RELEASE"+File.separator+"DSDM-Web"+File.separator+"WebApp"+File.separator+"sitemap");
    }

    //실제 존재하는 파일의 이름 저장
    private static void RealShowFilesInDir(String dirPath){
        File dir = new File(dirPath);
        File files[] = dir.listFiles();
        
        for(int i=0; i<files.length; i++){
            File file = files[i];
            if(file.isDirectory()){
                RealShowFilesInDir(file.getPath());
            }else{
                //System.out.println("file : " + file);
                //showFindExt(file);
                if(file.getName().endsWith(".jsp")){
                    realFileList.add(file.getName());
                    //System.out.println("file : " + file.getName());

                    count++;
                }
            }
        }
    }

    // 파일 내 라인을 읽어서 .jsp가 있으면 저장
    private static void showPathInFile(String dirPath) {
        File dir = new File(dirPath);
        File files[] = dir.listFiles();
        
        for(int i=0; i<files.length; i++){
            File file = files[i];
            if(file.isDirectory()){
                RealShowFilesInDir(file.getPath());
            }else{
                if(file.getName().endsWith(".jsp")){
                    BufferedReader inFile =null;
                    try{
                        inFile = new BufferedReader(new FileReader(file));
                        String sLine = null;
                        // while((sLine = inFile.readLine()) != null){
                        //     System.out.println(sLine);
                        // }
                        while((sLine = inFile.readLine()) != null){
                            String jspFile = "";
                            //System.out.println(sLine);
                            Pattern pattern = Pattern.compile(regExp);
                            Matcher matcher = pattern.matcher(sLine);
                            // System.out.println("matcher.find()" + matcher.find());
                            while(matcher.find() != false){
                                // if(matcher.group(1) == null){
                                //     break;
                                // }
                                System.out.println(matcher.group(0));
                            }
                            
                        }
                    }catch(IOException e){
                        e.printStackTrace();
                    }

                    if(inFile != null){

                        try {
                            inFile.close();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }

                }
            }
        }
    }

}
