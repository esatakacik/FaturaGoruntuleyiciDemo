package demo;

import java.io.PrintStream;
import javax.xml.transform.ErrorListener;
import javax.xml.transform.TransformerException;

public class MyErrorListener
  implements ErrorListener
{
  String hata;
  
  public MyErrorListener(String hata)
  {
    this.hata = hata;
  }
  
  public void warning(TransformerException e)
    throws TransformerException
  {
    show("Warning", e);
    throw e;
  }
  
  public void error(TransformerException e)
    throws TransformerException
  {
    show("Error", e);
    throw e;
  }
  
  public void fatalError(TransformerException e)
    throws TransformerException
  {
    show("Fatal Error", e);
    throw e;
  }
  
  private void show(String type, TransformerException e)
  {
    Doc.saxonHata = Doc.saxonHata + type + ": " + e.getMessage();
    System.out.println(type + ": " + e.getMessage());
    if (e.getLocationAsString() != null)
    {
      System.out.println(e.getLocationAsString());
      Doc.saxonHata = Doc.saxonHata + e.getMessage() + "\n" + e.getLocationAsString();
    }
    Doc.saxonHata += "\n";
  }
}

