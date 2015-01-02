module Gramercy
  module Meta
    class RootsController < ApplicationController

      def index
        @roots = Gramercy::Meta::Root.all.order(base_form: :asc).to_a
        @roots_with_contexts = Gramercy::Meta::Root.as('root').contexts(:c).pluck('root.base_form, c.name').inject({}){|a, r| a[r[0]] ||= []; a[r[0]] << r[1]; a}
        @roots_with_forms = Gramercy::Meta::Root.as('root').forms(:f).pluck('root.base_form, f.base_form').inject({}){|a, r| a[r[0]] ||= []; a[r[0]] << r[1]; a}
      end

      def create
        root = Gramercy::Meta::Root.find_or_create_by(base_form: root_params[:base_form])
        context = Gramercy::Meta::Context.find(params[:context_id])
        if context.add_expression(root, params[:positivity])
          redirect_to gramercy_meta_context_url(context)
        else
          flash[:notice] = "The root could not be added."
        end
      end

      def show
        @root = Gramercy::Meta::Root.find(params[:id])
      end

      private

      def root_params
        params.require(:gramercy_meta_root).permit(:base_form)
      end

    end
  end
end