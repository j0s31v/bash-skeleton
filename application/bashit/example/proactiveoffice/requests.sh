#!/bin/bash

alias req::po3_landingpage="req::get '/login'"
alias req::po3_dashboard="req::get '/'"
alias req::po3_projects="req::get '/projects'"
alias req::po3_logout="req::get '/logout'"
alias req::po3_contracts="req::get '/contracts'"
alias req::po3_portfolio="req::get '/portfolio/?customfilter[view]=open'"
alias req::po3_portfolio_indicators="req::get '/portfolio/indicators/'"
alias req::po3_datainput="req::get '/datainput/'"
alias req::po3_costinput="req::get '/costinput/'"
alias req::po3_costinput_import="req::get '/costinput/import/'"
alias req::po3_datainput_assistance="req::get '/datainput/assistance/'"
alias req::po3_files="req::get '/files/'"
alias req::po3_reports="req::get '/reports/'"
alias req::po3_reports_contract="req::get '/reports/full_page_contract'"
alias req::po3_reports_costs="req::get '/reports/costs/summary'"
alias req::po3_reports_tasks="req::get '/reports/tasks/general'"
alias req::po3_admin="req::get '/admin/'"
alias req::po3_admin_roles="req::get '/admin/roles/'"
alias req::po3_admin_news="req::get '/admin/news/'"
alias req::po3_admin_datainput="req::get '/datainput/admin/datainput/disabling'"
alias req::po3_admin_portfoliofilters="req::get '/admin/portfoliofilters/'"

function req::po3_login() {

  local _data="_username=$__request_username&_password=$__request_password&_remember_me=on&target_path="
  req::post "/check" "$_data"  
}