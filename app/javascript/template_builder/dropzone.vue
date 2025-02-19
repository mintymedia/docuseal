<template>
  <div
    class="flex h-60 w-full"
    @dragover.prevent
    @drop.prevent="onDropFiles"
  >
    <label
      class="w-full relative bg-base-200 hover:bg-base-200/70 rounded-md border border-base-content border-dashed"
      :for="inputId"
      :class="{ 'opacity-50': isLoading || isProcessing }"
    >
      <div class="absolute top-0 right-0 left-0 bottom-0 flex items-center justify-center">
        <div class="flex flex-col items-center">
          <IconInnerShadowTop
            v-if="isLoading || isProcessing"
            class="animate-spin"
            :width="40"
            :height="40"
          />
          <IconCloudUpload
            v-else
            :width="40"
            :height="40"
          />
          <div
            v-if="message"
            class="font-medium text-lg mb-1"
          >
            {{ message }}
          </div>
          <div class="text-sm">
            <span class="font-medium">Click to upload</span> or drag and drop files
          </div>
        </div>
      </div>
      <form
        ref="form"
        class="hidden"
      >
        <input
          :id="inputId"
          ref="input"
          type="file"
          name="files[]"
          accept="image/*, application/pdf"
          multiple
          @change="upload"
        >
      </form>
    </label>
  </div>
</template>

<script>
import Upload from './upload'
import { IconCloudUpload, IconInnerShadowTop } from '@tabler/icons-vue'

export default {
  name: 'FileDropzone',
  components: {
    IconCloudUpload,
    IconInnerShadowTop
  },
  props: {
    templateId: {
      type: [Number, String],
      required: true
    },
    isDirectUpload: {
      type: Boolean,
      required: true,
      default: false
    }
  },
  emits: ['success'],
  data () {
    return {
      isLoading: false,
      isProcessing: false
    }
  },
  computed: {
    inputId () {
      return 'el' + Math.random().toString(32).split('.')[1]
    },
    message () {
      if (this.isLoading) {
        return 'Uploading...'
      } else if (this.isProcessing) {
        return 'Processing...'
      } else {
        return 'Add PDF documents or images'
      }
    }
  },
  methods: {
    upload: Upload.methods.upload,
    onDropFiles (e) {
      this.$refs.input.files = e.dataTransfer.files

      this.upload()
    }
  }
}
</script>
