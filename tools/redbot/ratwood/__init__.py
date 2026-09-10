from .ratwood import Ratwood


async def setup(bot):
    await bot.add_cog(Ratwood(bot))
