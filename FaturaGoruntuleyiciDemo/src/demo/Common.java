package demo;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;

public class Common
{
  public static boolean isOSWindows()
  {
    String os = System.getProperty("os.name").toLowerCase();
    return os.indexOf("win") >= 0;
  }
  
  public static byte[] fromIStoBytes(InputStream is)
    throws IOException
  {
    byte[] buffer = new byte['?'];
    ByteArrayOutputStream baos = new ByteArrayOutputStream(2048);
    int length = is.read(buffer);
    while (length != -1)
    {
      baos.write(buffer, 0, length);
      length = is.read(buffer);
    }
    return baos.toByteArray();
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
}
