module Gramercy
  module Meta
    class ContextsController < ApplicationController

      before_filter :scope_context, only: [:edit, :show]
      def index
        @contexts = Gramercy::Meta::Context.all.order(name: :asc)
      end

      def create
        if context = Gramercy::Meta::Context.create!(context_params)
          redirect_to gramercy_meta_context_url(context)
        else
          render :new
        end
      end

      def destroy
        @context.destroy
        redirect_to gramercy_meta_contexts_url
      end

      def show
        @roots = @context.roots.each_with_rel.map{|n, r| n.positivity = r.positivity; n}.flatten.sort_by(&:positivity)
      end

      private

      def scope_context
        @context = Gramercy::Meta::Context.find(params[:id])
      end

      def context_params
        params.require(:gramercy_meta_context).permit(:name)
      end

    end
  end
end