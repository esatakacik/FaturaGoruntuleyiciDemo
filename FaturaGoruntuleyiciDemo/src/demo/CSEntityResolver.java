package demo;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.ext.EntityResolver2;

public class CSEntityResolver
  implements EntityResolver2
{
  String baseURI2;
  private static HashMap<String, String> xsdCatalog = new HashMap();
  
  String findSchemaName(String s)
  {
    int q1i = -1;
    String quot = "/";
    q1i = s.lastIndexOf(quot);
    return s.substring(q1i + 1);
  }
  
  public void setBaseURI2(String baseURI)
  {
    this.baseURI2 = baseURI;
  }
  
  @Deprecated
  public void setAllSchemaPath(String bos) {}
  
  public InputSource resolveEntity(String publicId, String systemId)
  {
    try
    {
      return resolveEntity(null, publicId, null, systemId);
    }
    catch (SAXException e)
    {
      e.printStackTrace();
    }
    catch (IOException e)
    {
      e.printStackTrace();
    }
    return null;
  }
  
  public InputSource resolveEntity(String name, String publicId, String baseURI, String systemId)
    throws SAXException, IOException
  {
    InputSource is = null;
    try
    {
      is = getExternalSubset2(findSchemaName(systemId), baseURI);
    }
    catch (FileNotFoundException localFileNotFoundException) {}
    return is;
  }
  
  public InputSource getExternalSubset2(String name, String baseURI)
    throws SAXException, IOException
  {
    if (xsdCatalog.size() == 0) {
      visitAllFiles(new File(this.baseURI2));
    }
    InputStream xmlConfigFileis = new FileInputStream((String)xsdCatalog.get(name));
    InputSource is = new InputSource(
      xmlConfigFileis);
    return is;
  }
  
  public InputSource getExternalSubset(String name, String baseURI)
    throws SAXException, IOException
  {
    return null;
  }
  
  public void visitAllFiles(File dir)
  {
    if (dir.isDirectory())
    {
      String[] children = dir.list();
      for (int i = 0; i < children.length; i++) {
        visitAllFiles(new File(dir, children[i]));
      }
    }
    else
    {
      xsdCatalog.put(dir.getName(), dir.getAbsolutePath());
    }
  }
}
