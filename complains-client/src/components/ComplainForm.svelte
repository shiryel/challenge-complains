<script>
  let complain = { title: null, description: null, company: {}, locale: {} };

  function handleForm() {
    fetch("http://localhost:4000/api/complains", {
      method: "post",
      body: JSON.stringify(complain),
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((res) => {
        if (res.status == 200) {
          return res.json();
        } else {
          throw new Error("Server error");
        }
      })
      .then((res) => {
        console.log(res);
      });
  }
</script>

<style>
  form {
    display: grid;
    grid-template:
      "label input"
      "label input"
      "label input"
      "label input"
      "label input"
      "label input"
      "label input"
      "button button";
    grid-template-columns: 1fr minmax(200px, 400px);
    grid-gap: 10px;
    padding: 10px;
    background-color: #D5DBE3;
    border-radius: 10px;
  }

  button {
    grid-area: button;
  }

  h3 {
    text-align: center;
  }

  @media (min-width: 480px) {
  }
</style>

<div>
<h3>Make your complain</h3>
<form>
  <label for="title">Title:</label>
  <input type="text" id="title" bind:value={complain.title} />

  <label for="description">Description:</label>
  <textarea id="description" bind:value={complain.description} />

  <label for="company_name">Company Name:</label>
  <input type="text" id="company_name" bind:value={complain.company.name} />

  <label for="company_description">Company Description:</label>
  <input type="text" id="company_description" bind:value={complain.company.description} />

  <label for="locale_country">Country:</label>
  <input type="text" id="locale_country" bind:value={complain.locale.country} />

  <label for="locale_state">State:</label>
  <input type="text" id="locale_state" bind:value={complain.locale.state} />

  <label for="locale_city">City:</label>
  <input type="text" id="locale_city" bind:value={complain.locale.city} />

  <button type="button" on:click={handleForm}>Send</button>
</form>
</div>
