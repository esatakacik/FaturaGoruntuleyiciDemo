package demo;

public class Invoice
{
  private String invoiceId;
  private String odenecekTutar;
  private String toplamTutar;
  private String digestValue;
  private String saticiVknTckn;
  private String aliciVknTckn;
  private String faturaDuzTarih;
  private String profileId;
  
  public String getToplamTutar()
  {
    return this.toplamTutar;
  }
  
  public void setToplamTutar(String toplamTutar)
  {
    this.toplamTutar = toplamTutar;
  }
  
  public String getAliciVknTckn()
  {
    return this.aliciVknTckn;
  }
  
  public void setAliciVknTckn(String aliciVknTckn)
  {
    this.aliciVknTckn = aliciVknTckn;
  }
  
  public String getFaturaDuzTarih()
  {
    return this.faturaDuzTarih;
  }
  
  public void setFaturaDuzTarih(String faturaDuzTarih)
  {
    this.faturaDuzTarih = faturaDuzTarih;
  }
  
  public String getProfileId()
  {
    return this.profileId;
  }
  
  public void setProfileId(String profileId)
  {
    this.profileId = profileId;
  }
  
  public String getInvoiceId()
  {
    return this.invoiceId;
  }
  
  public void setInvoiceId(String invoiceId)
  {
    this.invoiceId = invoiceId;
  }
  
  public String getOdenecekTutar()
  {
    return this.odenecekTutar;
  }
  
  public void setOdenecekTutar(String odenecekTutar)
  {
    this.odenecekTutar = odenecekTutar;
  }
  
  public String getDigestValue()
  {
    return this.digestValue;
  }
  
  public void setDigestValue(String digestValue)
  {
    this.digestValue = digestValue;
  }
  
  public String getSaticiVknTckn()
  {
    return this.saticiVknTckn;
  }
  
  public void setSaticiVknTckn(String saticiVknTckn)
  {
    this.saticiVknTckn = saticiVknTckn;
  }
}

