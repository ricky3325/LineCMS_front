<template>
<td>
    <button
        class="k-button k-grid-download-command"
        @click="selectHandler"
    >
    選擇
    </button>       
</td>
</template>
<script>

export default {
   props: {
        field: String,
        dataItem: Object,
        format: String,
        className: String,
        columnIndex: Number,
        columnsCount: Number,
        rowType: String,
        level: Number,
        expanded: Boolean,
        editor: String
    },
    methods: {
        selectHandler: function() {
            this.$emit('onselect', this.dataItem.檔案名稱);
        }
    }
}
</script>
<style scoped>
.k-grid-download-command
{
    color: white;
    background-color: #283B42;
}
.k-grid-edit-command
{
    color: white;
    background-color: #1D6A96;
}
.k-grid-remove-command
{
    color: white;
    background-color: #85b8cb;
}
</style>