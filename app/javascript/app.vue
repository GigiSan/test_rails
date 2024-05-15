<template>
  <div id="app">
    <input type="text" v-model="searchTerm" placeholder="Cerca per titolo o tag..." />
    <Spinner v-if="loading" />
    <post v-for="post in posts" :key="post.id" :post="post"></post>
    <p v-if="noPostsFound">Nessun post trovato!</p>
    <p v-if="fetchError">Non è stato possibile caricare i post, riprova più tardi.</p>
  </div>
</template>

<script>
import Post from './components/Post'
import Spinner from './components/Spinner';

const debounce = function(fn, wait) {
  let timer;
  return function (...args) {
    if (timer) {
      clearTimeout(timer);
    }
    const context = this;
    timer = setTimeout(() => {
      fn.apply(context, args);
    }, wait);
  }
}

export default {
  components: { Post, Spinner },

  data() {
    return {
      searchTerm: "",
      posts: [],
      loading: true,
      fetchError: false
    }
  },

  created() {
    this.debouncedFetch = debounce((term) => {
      fetch(`/api/posts/search/${term}`)
        .then(response => response.json())
        .then(data => {
          this.posts = data;
          this.fetchError = false;
        })
        .catch(_error => {
          this.fetchError = true;
          this.posts = []
        })
        .finally(() => {
          this.loading = false
        })
    }, 600);
  },

  mounted() {
    this.loading = true
    fetch('/api/posts')
    .then(response => response.json())
    .then(data => {
      this.posts = data;
      this.fetchError = false;
    })
    .catch(_error => {
      this.fetchError = true;
      this.posts = []
    })
    .finally(() => {
      this.loading = false
    })
  },

  computed: {
    noPostsFound: function() {
      return this.posts.length === 0 && !this.fetchError
    }
  },

  watch: {
    searchTerm(newVal) {
      this.loading = true
      this.debouncedFetch(newVal);
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}

input {
  margin: 0.5em 2em;
  width: 100%;
  max-width: 300px;
  font-size: 1em;
}
</style>
