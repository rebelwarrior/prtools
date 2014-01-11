require "watir-webdriver"
require 'fileutils'

CONTRATOS_URL = "http://contratos.ocpr.gov.pr/ContFilter.aspx"
# FECHA_START = Date.parse("#{ARGV[0]}/#{ARGV[0] == '2002' ? '07' : '01'}/01")
# FECHA_END = Date.today
FECHA_START = Date.parse(ARGV[0])
FECHA_END = Date.parse(ARGV[1])
FECHA_OFFSET = 90 # 14 days
FORMAT = "%-m/%-d/%Y"
DOWNLOAD_PATH = "/Users/rr/Downloads/"
PERM_PATH = "/Users/rr/data/contratos/"

fecha_current = FECHA_START
while fecha_current < FECHA_END do
	fecha_current_offset = fecha_current + FECHA_OFFSET
	puts "Processing #{fecha_current.strftime(FORMAT)} to #{fecha_current_offset.strftime(FORMAT)}"
	FileUtils.mkdir_p("#{PERM_PATH}/#{fecha_current}---#{fecha_current_offset}")
	download_directory = "#{PERM_PATH}/#{fecha_current}---#{fecha_current_offset}"
	profile = Selenium::WebDriver::Firefox::Profile.new
	profile['browser.download.folderList'] = 2 # custom location
	profile['browser.download.dir'] = download_directory
	profile["browser.helperApps.neverAsk.saveToDisk"] = "text/plain, application/vnd.ms-excel, text/csv, text/comma-separated-values, application/octet-stream"
	browser = Watir::Browser.new :firefox, :profile => profile
	browser.goto CONTRATOS_URL
	browser.select_list(:id => 'cboTipoBusqueda').select_value(0)
	browser.text_field(:id, 'WebDateChooserDesde_input').set(fecha_current.strftime(FORMAT))
	browser.text_field(:id, 'WebDateChooserHasta_input').set(fecha_current_offset.strftime(FORMAT))
	browser.button(:id, 'btnBuscar').click
	browser.button(:id, 'cmdExportToExcel').click
	fecha_current = fecha_current_offset
end