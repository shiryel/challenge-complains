<script>
	import Nav from '../components/Nav.svelte';

	export let segment;
</script>

<style>
	main {
		position: relative;
    display: flex;
    flex-direction: column;
    align-items: center;
		background-color: #B2C4CF;
		padding: 2em;
		margin: 0 auto;
    box-sizing: border-box;
    min-height: 89vh;
	}

  footer {
    display: flex;
    position: relative;
    bottom: 0;
    width: 100%;
    justify-content: center;
    align-items: center;
    background-color: #0E4B63;
    color: white;
  }
</style>

<Nav {segment}/>

<main>
	<slot></slot>

</main>

<footer>
  <p>Source code at <a href="https://github.com/shiryel/reclameaqui-challenge" target="_blank">Shiryel's Github</a></p>
</footer>
