<template>
<k-dialog  @close="cancel">
                <div :style="{ marginBottom: '1rem' }">
                    <label>
                    文件說明<br />
                    <k-input
                        style="width:400px"
                        type="text"
                        :name="'文件說明'"
                        v-model= "fileItemInEdit.文件說明"
                    ></k-input>
                    </label>
                </div>
                <div :style="{ marginBottom: '1rem' }">
                    <label>
                    檔案名稱<br />
                    <k-input
                        style="width:400px"
                        :name="'檔案名稱'"
                        v-model="fileItemInEdit.檔案名稱"
                    ></k-input>
                    </label>
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
   name:"QualityControlDoc_DialogContainer_New",
   components: {
        'k-input': Input,
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