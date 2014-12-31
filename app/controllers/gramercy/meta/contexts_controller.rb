module Gramercy
  module Meta
    class ContextsController < ApplicationController

      def index
        @contexts = Gramercy::Meta::Context.all.order(name: :asc)
      end

      def show
        @context = Gramercy::Meta::Context.find(params[:id])
        @roots = @context.roots.order(base_form: :asc).each_with_rel.map{|n, r| n.positivity = r.positivity; n}.flatten
      end

      def edit
        @context = Gramercy::Meta::Context.find(params[:id])
      end

    end
  end
end