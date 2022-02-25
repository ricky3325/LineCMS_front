<template>
<k-dialog  @close="cancel" width="200px" height="100px">
            <div class="switch-toggle switch-3 switch-candy">

            <input id="on" name="state-d" type="radio" checked="" />
            <label for="on" onclick="">簽核中</label>&nbsp;&nbsp;&nbsp;&nbsp;  
            <input id="na" name="state-d" type="radio" checked="checked" />
            <label for="na" class="disabled" onclick="">已核決</label>&nbsp;&nbsp;&nbsp;&nbsp; 

            <input id="off" name="state-d" type="radio" />
            <label for="off" onclick="">退回</label>

            </div>
            <dialog-actions-bar>
                <button
                    class="k-button"
                    @click="cancel"
                >
                    Cancel
                </button>
                <button
                    class="k-button k-primary"
                    @click="save"
                >
                    Save
                </button>
            </dialog-actions-bar>
        </k-dialog>
</template>
<script>
import { Dialog, DialogActionsBar } from '@progress/kendo-vue-dialogs';
import { Input } from '@progress/kendo-vue-inputs';

export default {
   name:"QualityControlDoc_DialogContainer_Approval",
   components: {
        'k-dialog': Dialog,
        'dialog-actions-bar': DialogActionsBar
    },
   props: {
      dataItem: Object
  },
  data: function(){
    return {
        fileItemInEdit: {
            guid:'',                
            文件說明:'',
            檔案名稱:''  
        }
    };
  },
  created: function(){
    if(this.$props.dataItem){
      this.fileItemInEdit = this.$props.dataItem;
    }
  },
  methods: {
      cancel(){
        this.$emit('cancel');
      },
      save(){
        this.$emit('save');
      }
  },
}
</script>