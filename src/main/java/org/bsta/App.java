package org.bsta;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;

/**
 * Hello world!
 *
 */
public class App 
{
    static int realFileCount = 0;
    static int callFileCount = 0;
    static List<String> realFileList = new ArrayList<>();
    static List<String> realFullPathList = new ArrayList<>();
    static List<String> pathInFileList = new ArrayList<>();
    static String regExp = "[a-zA-Z0-9_]*\\.jsp";
    public static void main( String[] args ) {
        
        String projectPath = System.getProperty("user.dir");
        System.out.println("path : " + projectPath);
        
        // 실제파일리스트
        realShowFilesInDir(projectPath + File.separator + "sample");
        
        // 파일 안에 호출된 .jsp 파일 리스트
        showPathInFile(projectPath + File.separator + "sample");
        
        // 호출되고 있는 파일과 실제 존재하는 파일을 비교해서 호출되고 있으면 usedFile에 넣는다.
        List<String> usedFile = new ArrayList<>();
        List<String> notUsedFile = new ArrayList<>();
        for(int i=0; i<pathInFileList.size(); i++){
            for(int j=0; j<realFileList.size(); j++){
                if((pathInFileList.get(i).equals(realFileList.get(j)))){
                    usedFile.add(realFullPathList.get(j));
                }
            }
        }
        Stream<String> stream = usedFile.stream().distinct();
        stream.forEach(x -> {}); // 임시로 아무것도 실행안함.

        // List<String> tmp = new ArrayList<>();
        String tmp = null;
        long size = 0;
        for(int i=0; i<realFullPathList.size(); i++){
            for(int j=0; j < usedFile.size(); j++){
                if(realFullPathList.get(i).equals(usedFile.get(j))){
                    tmp = realFullPathList.get(i);
                    // tmp.add(realFullPathList.get(i));
                    break;
                }
            }

            // for(int j=0; j < tmp.size(); j++){
            if(tmp == null){
                File tmpFile = new File(realFullPathList.get(i));
                if(tmpFile.exists()){
                    //System.out.println(tmpFile.getAbsolutePath());
                    if(tmpFile.getName().endsWith(".jsp")){
                        size += tmpFile.length();
                        // 삭제 로직
                        if(tmpFile.delete()){
                            System.out.println(tmpFile.getAbsolutePath() + " 삭제");
                        }
                    }
                }
            }
            // }
            // tmp.clear();
            tmp = null;
        }

        System.out.println("deleted size : " + size);
        
    }

    //실제 존재하는 파일의 이름 저장
    private static void realShowFilesInDir(String dirPath){
        File dir = new File(dirPath);
        File files[] = dir.listFiles();
        
        for(int i=0; i<files.length; i++){
            File file = files[i];
            if(file.isDirectory()){
                realShowFilesInDir(file.getPath());
            }else{
                
                if(file.getName().endsWith(".jsp") || file.getName().endsWith(".js") || file.getName().endsWith(".html")){
                    //System.out.println("realShowFilesInDir : " + file.getAbsolutePath());
                    realFileList.add(file.getName());
                    realFullPathList.add(file.getAbsolutePath());

                    //showPathInFile(file);
                    realFileCount++;
                }
            }
        }
    }

    // 파일 내 라인을 읽어서 .jsp가 있으면 저장
    //private static void showPathInFile(String dirPath) {
    private static void showPathInFile(String dirPath) {
        File dir = new File(dirPath);
        File files[] = dir.listFiles();
        
        for(int i=0; i<files.length; i++){
            File file = files[i];
            if(file.isDirectory()){
                // RealShowFilesInDir(file.getPath());
                showPathInFile(file.getPath());
                //showPathInFile(file);
            }else{
                if(file.getName().endsWith(".jsp") || file.getName().endsWith(".js") || file.getName().endsWith(".html")){
                    BufferedReader inFile =null;
                    try{
                        inFile = new BufferedReader(new FileReader(file));
                        String sLine = null;
                        
                        while((sLine = inFile.readLine()) != null){
                            Pattern pattern = Pattern.compile(regExp);
                            Matcher matcher = pattern.matcher(sLine);
                            
                            while(matcher.find() != false){
                                pathInFileList.add(matcher.group(0));
                                callFileCount++;
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

    private static void showPathInFile(File file) {
        
        if(file.getName().endsWith(".jsp")){
            BufferedReader inFile =null;
            try{
                inFile = new BufferedReader(new FileReader(file));
                String sLine = null;
                
                while((sLine = inFile.readLine()) != null){
                    Pattern pattern = Pattern.compile(regExp);
                    Matcher matcher = pattern.matcher(sLine);
                    
                    while(matcher.find() != false){
                        //pathInFileList.add(matcher.group(0));
                        callFileCount++;
                        System.out.println("showPathInFile : " + matcher.group(0));
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
