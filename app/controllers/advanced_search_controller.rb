class AdvancedSearchController < ApplicationController

  def index
    puts params[:criteria_list]
    @forms = FormSection.all
    @aside = 'shared/sidebar_links'
    new_search = !params[:criteria_list]
    if new_search
      @criteria_list = [SearchCriteria.new]
      @results = []
    else
      @criteria_list = (child_fields_selected?(params[:criteria_list]) ? SearchCriteria.build_from_params(params[:criteria_list]): [])
      append_advanced_user_criteria(params[:created_by_value], @criteria_list)
      @results = SearchService.search(@criteria_list)
    end
  end

  def child_fields_selected?(criteria_list)
     !criteria_list.first[1]["field"].blank? if !criteria_list.first[1].nil?
  end

  def append_advanced_user_criteria(value, list)
    if (value.length > 0)
      advanced_user_criteria = SearchCriteria.create_advanced_criteria({:field => "created_by", :value => value, :index => 12})
      list.push(advanced_user_criteria)
    end
  end
end