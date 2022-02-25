<template>
<k-dialog @close="cancel">
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
                        disabled="disabled"
                        style="width:400px;color:red"
                        :name="'檔案名稱'"
                        v-model="fileItemInEdit.檔案名稱"
                    ></k-input>
                    </label>
                </div>
                <div>
                    <QualityControlDocFileList @onselect='select'>
                    </QualityControlDocFileList>
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
import QualityControlDocFileList from '@/components/manager/QualityControlDocFileList.vue';
import { Dialog, DialogActionsBar } from '@progress/kendo-vue-dialogs';
import { Input } from '@progress/kendo-vue-inputs';
import { Editor, EditorTool } from '@progress/kendo-editor-vue-wrapper';
import $ from 'jquery';
export default {
   name:"QualityControlDoc_DialogContainer_Edit",
   components: {
        'k-input': Input,
        'k-dialog': Dialog,
        'dialog-actions-bar': DialogActionsBar,   
        QualityControlDocFileList,  
    },
   props: {
      dataItem: Object
  },
  mounted() {     
  }, 
  
  data: function(){
    return {
        fileItemInEdit: {
            guid:'',                
            文件說明:'',
            檔案名稱:''  
        },      
    };
  },
  created: function(){
    if(this.$props.dataItem){
      this.fileItemInEdit = this.$props.dataItem;
    }
  },
  methods: {
      select(fileName)
      {
        this.fileItemInEdit.檔案名稱=fileName;
      },
      cancel(){
        this.$emit('cancel');
      },
      save(){
        this.$emit('save');
      }
  },
}

</script>

