#if Rails.env.production?
  #wkhtmltopdf_path = "#{Rails.root}/bin/wkhtmltopdf-amd64"
#else
  # Linux (check your processor for Intel x86 or AMD x64)
  # wkhtmltopdf_path = "#{Rails.root}/bin/wkhtmltopdf-amd64"
  # wkhtmltopdf_path = "#{Rails.root}/bin/wkhtmltopdf-i386"
  # OS X
  #wkhtmltopdf_path = "C:/Program Files (x86)/wkhtmltopdf/wkhtmltopdf.exe"            
  # Windows
  # wkhtmltopdf_path = 'C:\Program Files/wkhtmltopdf/wkhtmltopdf.exe'
#end

if Rails.env.production?
  WickedPdf.config = {:exe_path => Rails.root.join('bin', 'wkhtmltopdf-amd64').to_s}
else
  WickedPdf.config = {
  :exe_path => 'C:/Program Files (x86)/wkhtmltopdf/wkhtmltopdf.exe'
}
end