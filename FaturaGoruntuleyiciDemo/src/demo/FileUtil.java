package demo;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class FileUtil
{
  public static void makeLocalDirectory(String localPath)
  {
    File f = new File(localPath);
    if (!f.exists()) {
      f.mkdir();
    }
  }
  
  public static void writeInputStreamToOutputStream(InputStream fis, OutputStream os)
    throws IOException
  {
    byte[] buffer = new byte['?'];
    int count = 0;
    while ((count = fis.read(buffer)) >= 0) {
      os.write(buffer, 0, count);
    }
    os.flush();
    os.close();
    fis.close();
  }
  
  public static void writeInputStreamToFile(InputStream inputStream, String fileName)
    throws IOException
  {
    OutputStream out = new FileOutputStream(new File(fileName));
    
    int read = 0;
    byte[] bytes = new byte['?'];
    while ((read = inputStream.read(bytes)) != -1) {
      out.write(bytes, 0, read);
    }
    inputStream.close();
    
    out.flush();
    out.close();
  }
  
  public static boolean delDir(String dizinAdi)
  {
    File dir = new File(dizinAdi);
    
    int j = 0;
    boolean ok = false;
    do
    {
      if (dir.isDirectory())
      {
        String[] children = dir.list();
        for (int i = 0; i < children.length; i++) {
          delDir(dizinAdi + "/" + children[i]);
        }
      }
      ok = dir.delete();
      j++;
    } while ((j < 5) && (!ok));
    return ok;
  }
  
  public static String getFileBaseName(String fileName)
  {
    if ((fileName != null) && (!"".equals(fileName)))
    {
      String[] baseName = fileName.split("\\.");
      if (baseName.length == 2) {
        return baseName[0];
      }
    }
    return "";
  }
  
  public static String findFileName(String filePath)
  {
    int q1i = -1;
    int q2i = -1;
    if (filePath == null) {
      return null;
    }
    q1i = filePath.lastIndexOf("/");
    q2i = filePath.lastIndexOf("\\");
    if (q2i > q1i) {
      q1i = q2i;
    }
    return filePath.substring(q1i + 1);
  }
  
  public static String concatPathAndFileName(String path, String fileName)
  {
    return path + File.separator + fileName;
  }
}
